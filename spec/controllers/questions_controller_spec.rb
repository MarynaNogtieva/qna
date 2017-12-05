require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    
    before { get :index }
    it 'populates an array of all quetions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
  
  describe 'GET #show' do
    before { get :show, params: { id: question } }
    
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
  
  describe 'Get #new' do
    before { get :new }
    
    it 'assigns a new @uestion to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    
    it 'render new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'Get #edit' do
      before { get :edit, params: { id: question } }
      
      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end
      
      it 'render new edit' do
        expect(response).to render_template :edit
      end
  end
  
  describe 'Post #create' do
    context'with valid attrs' do
      it 'saves the new question in DB' do
        # old_count = Question.count
        # post :create, attributes_for(:question) #gets parameter hash from FactoryBot
        # expect(Question.count).to eq old_count +1
        expect { post :create, params: { question: attributes_for(:question) } }
                .to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context'invalid object' do
      
    end
  end
end
