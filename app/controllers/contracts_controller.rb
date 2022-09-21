class ContractsController < ApplicationController
  def show
    @contract = Contract.find(params[:id])
    @player = Player.find(@contract.player_id)
    @team = Team.find(@player.team_id)
  end

  def new
    @contract = Contract.new
    @player = Player.find(params[:player_id])
  end

  def create
    @contract = Contract.new(contract_params)
    @contract.player_id = params[:player_id]
    @contract.team_id = params[:team_id]

    if @contract.save
      redirect_to team_player_path(params[:team_id], params[:player_id])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @contract = Contract.find(params[:id])
    @player = Player.find(params[:player_id])
  end

  def update
    @contract = Contract.find(params[:id])
    @contract.team_id = params[:team_id]

    if @contract.update!(contract_params)
      redirect_to team_player_contract_path(params[:team_id], params[:player_id], params[:id])
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def contract_params
    params.require(:contract).permit(:year_1, :year_2, :year_3, :year_4, :year_5, :year_6, :waived, :two_way)
  end
end
