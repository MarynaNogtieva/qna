require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }


  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

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

    it 'assigns ne answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    
    it 'assigns a new @question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    
    it 'render new view' do
      expect(response).to render_template :new
    end
  end
  
  # describe 'GET #edit' do
  #   sign_in_user
  #   before { get :edit, params: { id: question } }
    
  #   it 'assigns the requested question to @question' do
  #     expect(assigns(:question)).to eq question
  #   end
    
  #   it 'render new edit' do
  #     expect(response).to render_template :edit
  #   end
  # end
  
  describe 'POST #create' do
    sign_in_user
    context'with valid attrs' do
      it 'saves the new question in DB' do
        # old_count = Question.count
        # post :create, params: { question: attributes_for(:question)} #gets parameter hash from FactoryBot
        # expect(Question.count).to eq old_count +1
        expect { post :create, params: { question: attributes_for(:question)} }
                .to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context'invalid object' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question)} }
        .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context'with valid attributess' do
      it 'assigns the requested question to @question'do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js}
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes'do
        patch :update, params: {id: question, question: {title: "new title", body: "new body"}, format: :js}
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it "user cannot change somebody else's question" do
        other_user = create(:user)
        other_question = create(:question, user: other_user)
        patch :update, params: {id: question, question: {title: 'some title', body: 'some body'}, format: :js}

        other_question.reload
        expect(question.title).to_not eq 'some title'
        expect(question.body).to_not eq 'some body'
      end 
    end

    context'with invalid attributess' do
      before { patch :update, params: {id: question, question: {title: 'MyString', body: 'MyText'}}, format: :js }
      before { patch :update, params: {id: question, question: {title: "new title", body: nil}}, format: :js }
      
      it 'does not change question attributes' do 
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before {question}

    it 'deletes question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end

    it 'cannot delete somebody else answer' do
      random_user = create(:user)
      random_question = create(:question, user: random_user)

      expect { delete :destroy, params: {id: random_question} }.to_not change(Question, :count)
    end
  end
end
