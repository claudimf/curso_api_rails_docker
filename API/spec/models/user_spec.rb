# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  authentication_token   :string(30)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'has a valid factory' do
    let(:user) { create(:user) }

    it 'it gets valid' do
      expect(user.valid?).to eq true
    end

    it 'it gets created' do
      expect(user.new_record?).to eq false
    end
  end

  describe 'validations' do
    context 'have_many' do
      it { should have_many(:contacts).dependent(:destroy) }
    end
  end

end