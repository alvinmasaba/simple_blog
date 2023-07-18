class TradeException < ApplicationRecord
    belongs_to :team
  
    validates :amount, numericality: { greater_than: 0 }
    validates :expiry, presence: true
    #validates :exception_type, presence: true, inclusion: { in: ['MLE', 'BAE', 'TPE'] } # Add any other types as per NBA CBA
  end
  