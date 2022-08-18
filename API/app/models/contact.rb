# == Schema Information
#
# Table name: contacts
#
#  id          :bigint           not null, primary key
#  birthday    :date
#  description :text
#  email       :string
#  name        :string
#  phone       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_contacts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Contact < ApplicationRecord
  belongs_to :user
  validates :name, :user, presence: true


  def resume_info
    {
      name: name,
      age: Time.now.to_date.year - birthday.year
    }
  end
end
