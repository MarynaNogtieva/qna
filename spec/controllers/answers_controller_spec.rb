require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  
  describe 'Get #new' do
    before{ get :new, params: { question_id: question} }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    
    it 'render new view' do
      expect(response).to render_template :new
    end
  end
end
