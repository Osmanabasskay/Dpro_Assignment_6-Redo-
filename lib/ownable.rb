# Ownable module for classes that require owner privileges
module Ownable
  attr_accessor :owner
  
  def initialize(owner)
    @owner = owner
  end
  
  def owned_by?(person)
    @owner == person
  end
  
  def transfer_ownership(new_owner)
    @owner = new_owner
  end
end
