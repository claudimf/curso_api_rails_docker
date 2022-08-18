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
require 'rails_helper'

RSpec.describe Contact, type: :model do

  describe 'has a valid factory' do
    let(:contact) { create(:contact) }

    it 'it gets valid' do
      expect(contact.valid?).to eq true
    end

    it 'it gets created' do
      expect(contact.new_record?).to eq false
    end
  end

  describe 'validations' do
    context 'of attributes' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:user) }
    end
    context 'belong_to' do
      it { should belong_to(:user) }
    end
  end

end
