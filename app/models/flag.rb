class Flag < ActiveRecord::Base
  
  belongs_to :flaggable, :polymorphic => true
  
  def self.report(obj, body=nil)
    create( { flaggable: obj, body: body } )
  end

  def clean_up
    flag = Flag.find id
    case flag.flaggable_type 
      when 'User'
        clean_up_user
      when 'Post'
        clean_up_post
    end
  end

private
  
  def clean_up_user
    flaggable.image = nil
    flaggable.image_url = nil
    flaggable.save
    destroy
  end

  def clean_up_post
    flaggable.destroy
    destroy
  end

end
