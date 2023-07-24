import { Controller } from "stimulus"

export default class extends Controller {
  loadTeamAssets(event) {
    const teamId = event.target.value; // Get the selected team's ID from the dropdown
    const teamNumber = event.target.closest('.team-selector').dataset.teamNumber;
    const teamName = event.target.options[event.target.selectedIndex].text;

  
    fetch(`/trade_machine/load_assets?team_id=${teamId}&team_number=${teamNumber}`)
      .then(response => response.text())
      .then(html => {
        // Assuming your server responds with a Turbo Stream, Turbo will handle the update automatically
        // If your server responds with plain HTML, manually update the UI:
        const teamAssetsDiv = document.querySelector(`#team-assets-${teamNumber}`);
        teamAssetsDiv.innerHTML = html;
      });
    
    // Hide the dropdown and show the 'Change Team' link
    event.target.style.display = 'none';
    const changeTeamLink = document.createElement('a');
    changeTeamLink.href = '#';
    changeTeamLink.textContent = 'Change Team';
    changeTeamLink.dataset.action = "click->trade#showTeamDropdown";
    event.target.parentNode.insertBefore(changeTeamLink, event.target.nextSibling);

    const teamLink = document.createElement('a');
    teamLink.href = `/teams/${teamId}`;
    teamLink.textContent = teamName;
    teamLink.target = '_blank';
    teamLink.style.marginRight = "10px";
    event.target.parentNode.insertBefore(teamLink, event.target.nextSibling);
  }

  addAssetToTrade(event) {
    let assetId = event.currentTarget.dataset.assetId;
    let destinationDropdown = document.querySelector(`.trade-destination-dropdown[data-asset-id="${assetId}"]`);
    let destinationTeamNumber = destinationDropdown.value;
    
    // Add the asset to the destination team's incoming assets
    // This could be done using a JavaScript data structure, or you could append it directly to the UI
    // For simplicity, we'll append it directly to the UI
    
    let destinationAssetsDiv = document.querySelector(`#team-assets-${destinationTeamNumber}`);
    let assetName = event.currentTarget.closest('.asset').querySelector('.asset-name').textContent;
    
    destinationAssetsDiv.innerHTML += `<div class="incoming-asset">${assetName}</div>`;
    
    // Optionally, you could also remove the asset from the current team's list or mark it as "traded"
  }

  addAssetToSlot(event) {
    const assetId = event.target.value; 
    const assetName = event.target.options[event.target.selectedIndex].text;
    const teamNumber = event.target.closest('.team-selector').dataset.teamNumber;
    const assetRow = document.querySelector(`#team-assets-${teamNumber}`);

    assetRow.innerHTML += `
      <tr class="selected-asset" data-asset-id="${assetId}">
        <td>${assetName}</td>
        <td>
          <button data-action="click->trade#cycleTradeDestination">N/A</button>
        </td>
        <td>N/A</td>
        <td>
          <button data-action="click->trade#removeAssetFromSlot">Remove</button>
        </td>
      </tr>
    `;

    // Remove the asset from the dropdown
    const optionToRemove = event.target.querySelector(`option[value="${assetId}"]`);
    optionToRemove && optionToRemove.remove();
  }

  cycleTradeDestination(event) {
    const currentTeamName = event.target.textContent;
    const allTeams = Array.from(document.querySelectorAll('select[id^="team"] option'))
                           .map(opt => opt.textContent)
                           .filter(name => name && name !== currentTeamName);
    
    const currentIndex = allTeams.indexOf(currentTeamName);
    const nextIndex = (currentIndex + 1) % allTeams.length;
    event.target.textContent = allTeams[nextIndex];
  }

  showTeamDropdown(event) {
    event.preventDefault();

    // Ask for confirmation
    if(!confirm("Are you sure you want to change the team? All asset selections will be cleared.")) {
      return; // User clicked 'Cancel', do nothing and exit the function
    }


    // Retrieve the dropdown for the team
    const teamDropdown = event.target.previousElementSibling.previousElementSibling;

    // Display the team dropdown
    teamDropdown.style.display = 'block';

    // Remove the asset dropdown
    const assetDropDown = event.target.nextElementSibling;
    assetDropDown.remove();

    // Remove the "Change Team" link itself
    event.target.remove();

    // Remove the team link (team name)
    const teamLink = teamDropdown.nextElementSibling;
    teamLink.remove();

    // Clear the selected assets for the team
    const teamAssetsDiv = teamDropdown.closest('.team-selector').querySelector('.team-assets');
    teamAssetsDiv.innerHTML = '';

    // Reset the team dropdown (optional)
    teamDropdown.selectedIndex = 0;
  }


  removeAssetFromSlot(event) {
    const row = event.target.closest('.selected-asset')
    const teamNumber = event.target.closest('.team-selector').dataset.teamNumber;
    const dropdown = document.querySelector(`#asset${teamNumber}`);
    const assetName = event.target.closest('.selected-asset').textContent.replace("N/A", "").replace("Remove", "").trim(); // Removes the "N/A" and "Remove" from the content to get the asset name.

    // Create an option for the removed asset and add it back to the dropdown
    const optionToAdd = document.createElement("option");
    optionToAdd.value = assetId;
    optionToAdd.textContent = assetName;  // Using the trimmed name of the Asset
    dropdown.appendChild(optionToAdd);

    // Remove the asset div from the slots
    row.remove();
  }
}


function evaluateTrade() {
    let teamsData = {};  // This will store the trading data for each team

    // Loop over each team's assets and gather the trading data
    // This is a simple example, and you might want to expand on this, e.g., by differentiating between outgoing and incoming assets
    document.querySelectorAll('.team-assets').forEach((teamAssetsDiv, teamNumber) => {
        teamsData[teamNumber] = {
            assets: Array.from(teamAssetsDiv.querySelectorAll('.asset')).map(assetDiv => assetDiv.textContent)
        };
    });

    // Send the teamsData to the Rails backend for evaluation
    fetch('/path_to_evaluate_trade_endpoint', {
        method: 'POST',
        body: JSON.stringify({ teams: teamsData }),
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': getMetaValue("csrf-token")
        }
    }).then(response => response.json())
      .then(data => {
        document.querySelector('#trade-evaluation-result').textContent = data.message;
      });
}

// Helper function to get meta values, e.g., the CSRF token
function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`);
  return element.getAttribute("content");
}