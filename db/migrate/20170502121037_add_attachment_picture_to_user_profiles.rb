class AddAttachmentPictureToUserProfiles < ActiveRecord::Migration
  def self.up
    change_table :user_profiles do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :user_profiles, :picture
  end
end
