class TradeException < ApplicationRecord
    after_create :create_corresponding_asset
    
    belongs_to :team
    has_one :asset, as: :assetable
  
    validates :amount, numericality: { greater_than: 0 }
    validates :expiry, presence: true
    #validates :exception_type, presence: true, inclusion: { in: ['MLE', 'BAE', 'TPE'] } # Add any other types as per NBA CBA

    private

    def create_corresponding_asset
      Asset.create(assetable: self, team: self.team)
    en
  end
  