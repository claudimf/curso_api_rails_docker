# frozen_string_literal:true

require 'rails_helper'

RSpec.describe 'Contacts API' do
  describe "GET /api/v1/contacts" do
    it " without login need to be redirect to root" do
      get api_v1_contacts_path
      expect(response).to have_http_status(302)
      expect(response.location).to eq("http://www.example.com/users/sign_in")
    end

    context "User logged" do
      let!(:user){ create(:user) }
      let!(:contact_list){ create_list(:contact, 3, user: user) }
      let(:get_call){
        get api_v1_contacts_path, as: :json, headers: {
          "X-User-Email" => user.email,
          "X-User-Token" => user.authentication_token
        }
      }
      
      it " get successful" do
        get_call
        expect(response).to be_successful
      end

      it " get the list of contacts" do
        get_call
        json_response = JSON.parse(response.body)

        expect(json_response.map{|e| e["id"]}).to match_array(contact_list.map(&:id))
      end
    end
  end

  describe "GET /api/v1/contacts/:id" do
    let!(:user){ create(:user) }
    let!(:contact){ create(:contact, user: user) }

    it "#show without login need to be redirect to root" do
      get api_v1_contact_path(contact.id)
      expect(response).to have_http_status(302)
      expect(response.location).to eq("http://www.example.com/users/sign_in")
    end

    context "#show User logged" do
      context "get user contact" do
        let(:get_show_call){
          get api_v1_contact_path(contact.id), as: :json, headers: {
            "X-User-Email" => user.email,
            "X-User-Token" => user.authentication_token
          }
        }
        
        it " get successful" do
          get_show_call
          expect(response).to be_successful
        end

        it " get contact" do
          get_show_call
          json_response = JSON.parse(response.body)

          expect(json_response["id"]).to eq(contact.id)
        end
      end

      context "get contact from other user" do
        let!(:other_contact){ create(:contact) }
        let(:get_show_call){
          get api_v1_contact_path(other_contact.id), as: :json, headers: {
            "X-User-Email" => user.email,
            "X-User-Token" => user.authentication_token
          }
        }
        
        it " return forbidden" do
          get_show_call
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe "POST /api/v1/contacts" do
    let!(:contact_params){ attributes_for(:contact) }
    let(:post_call){
      post api_v1_contacts_path, as: :json, params: { contact: contact_params }
    }

    it " without login need to be redirect to root" do
      post_call
      expect(response).to have_http_status(:unauthorized)
    end

    context "User logged" do
      context "#create with valid params" do
        let!(:user){ create(:user) }
        let!(:contact_params){ attributes_for(:contact, user: user) }
        let(:post_call){
          post api_v1_contacts_path, as: :json, params: { contact: contact_params }, headers: {
            "X-User-Email" => user.email,
            "X-User-Token" => user.authentication_token
          }
        }
        
        it " get successful" do
          post_call
          expect(response).to be_successful
        end

        it " creates a contact in the database" do
          expect { post_call }.to change { Contact.count }.by(1)
        end
      end

      context "#create with invalid params" do
        let!(:user){ create(:user) }
        let!(:invalid_contact_params){ attributes_for(:contact, user: nil, name: nil) }
        let(:post_call){
          post api_v1_contacts_path, as: :json, params: { contact: invalid_contact_params }, headers: {
            "X-User-Email" => user.email,
            "X-User-Token" => user.authentication_token
          }
        }
        
        it " get successful" do
          post_call
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it " to not creates a contact in the database" do
          expect { post_call }.to change { Contact.count }.by(0)
        end
      end
    end
  end

  describe "PUT /api/v1/contacts/:id" do
    let!(:user){ create(:user) }
    let!(:contact){ create(:contact, user: user) }

    context "User not logged" do
      let!(:contact_params){ attributes_for(:contact) }
      let(:put_call){
        put api_v1_contact_path(contact.id), as: :json, params: { contact: contact_params }
      }

      it " without login need to be redirect to root" do
        put_call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "User logged" do
      context "#update with valid params" do
        let!(:contact_params){ attributes_for(:contact, user: user) }
        let(:put_call){
          put api_v1_contact_path(contact.id), as: :json, params: { contact: contact_params }, headers: {
            "X-User-Email" => user.email,
            "X-User-Token" => user.authentication_token
          }
        }
        
        it " get successful" do
          put_call
          expect(response).to be_successful
        end

        it " updates attributes" do
          expect(
            contact.slice(contact_params.keys).values
          ).to_not eq(contact_params.values)

          put_call
          contact.reload

          expect(
            contact.slice(contact_params.keys).values
          ).to eq(contact_params.values)
        end
      end

      context "#update with invalid params" do
        let!(:invalid_contact_params){ attributes_for(:contact, user: nil, name: nil) }
        let(:put_call){
          put api_v1_contact_path(contact.id), as: :json, params: { contact: invalid_contact_params }, headers: {
            "X-User-Email" => user.email,
            "X-User-Token" => user.authentication_token
          }
        }
        
        it " get successful" do
          put_call
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it " to not updates attributes" do
          expect(
            contact.slice(:name, :email, :phone, :description).values
          ).to_not eq(invalid_contact_params.values)

          put_call
          contact.reload

          expect(
            contact.slice(:name, :email, :phone, :description).values
          ).to_not eq(invalid_contact_params.values)
        end
      end
    end
  end

  describe "DELETE /api/v1/contacts/:id" do
    let!(:user){ create(:user) }
    let!(:contact){ create(:contact, user: user) }

    it "#destroy without login need to be redirect to root" do
      delete api_v1_contact_path(contact.id)
      expect(response).to have_http_status(302)
      expect(response.location).to eq("http://www.example.com/users/sign_in")
    end

    context "#destroy User logged" do
      let(:delete_call){
        delete api_v1_contact_path(contact.id), as: :json, headers: {
          "X-User-Email" => user.email,
          "X-User-Token" => user.authentication_token
        }
      }
      
      it " delete successful" do
        delete_call
        expect(response).to be_successful
      end

      it " delete contact" do
        delete_call
        json_response = JSON.parse(response.body)

        expect(json_response["message"]).to eq('Contact destroyed')
      end
    end
  end
end
