import { Controller } from "stimulus"

export default class extends Controller {
  loadTeamAssets(event) {
    const teamId = event.target.value; // Get the selected team's ID from the dropdown
    const teamNumber = event.target.closest('.team-selector').dataset.teamNumber;
  
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
    const assetSlotDiv = document.querySelector(`#team-assets-${teamNumber}`);
  
    assetSlotDiv.innerHTML += `
      <div class="selected-asset" data-asset-id="${assetId}">
        ${assetName} 
        <button data-action="click->trade#cycleTradeDestination">N/A</button>
      </div>
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
    const dropdown = event.target.previousSibling;
    dropdown.style.display = 'block';
    event.target.remove();
  
    // Clear the selected assets
    const teamAssetsDiv = dropdown.closest('.team-selector').querySelector('.team-assets');
    teamAssetsDiv.innerHTML = '';
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