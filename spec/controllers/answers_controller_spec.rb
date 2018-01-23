require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:other_answer) { create(:answer, user: other_user, question: question) }

  describe 'POST #create' do
    sign_in_user
    context'with valid attributes' do
      it 'should save @answer to DB' do
        expect { post :create, params: { question_id: question, format: :js, answer: attributes_for(:answer) } }
        .to change(question.answers, :count).by(1)

        expect { post :create, params: { question_id: question, format: :js, answer: attributes_for(:answer) } }
        .to change(user.answers, :count).by(1)
      end

      it 'should render a template after saving' do
        post :create, params: { question_id: question, format: :js, answer: attributes_for(:answer) }
        expect(response).to render_template 'create'
      end
    end

    context'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, format: :js, answer: attributes_for(:invalid_answer)} }
        .to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    before { answer }

    def update_answer(attrs)
      patch :update, params: {id: answer, question_id: question, answer: attrs, format: :js}
    end

    it 'assignes requested answer to @answer' do
      update_answer(attributes_for(:answer))
      expect(assigns(:answer)).to eq answer
    end

    it 'assignes @question' do
      update_answer(attributes_for(:answer))
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes'do
      patch :update, params: {id: answer, question_id: question, answer:{body: 'updated answer'}, format: :js}
      answer.reload

      expect(answer.body).to eq 'updated answer'
    end

    it 'cannot change attributes for the non-author' do
      patch :update, params: {id: answer, question_id: question, answer:{body: 'updated answer'}, format: :js}
      other_answer.reload
      expect(other_answer.body).to_not eq 'updated answer'
    end

    it 'renders update template' do 
      update_answer(attributes_for(:answer))
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    context'user is an author' do
      sign_in_user
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, params: {question_id: question, id: answer, format: :js} }.to change(Answer, :count).by(-1)
      end
    end

    context'user is not an author' do
      it 'tries to delete answer' do
        random_user = create(:user)
        somebody_answer = create(:answer, user: random_user, question: question)
        expect { delete :destroy, params: {question_id: question, id: somebody_answer, format: :js} }.to_not change(Answer, :count)
      end
    end
  end

  describe 'POST #best_answer' do
    sign_in_user
    def choose_best_answer
      post :best_answer, params: {id: answer, question_id: question, format: :js}
    end
    
    it 'assigns the requested answer to @answer' do
      choose_best_answer
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the @question' do
      choose_best_answer
      expect(assigns(:question)).to eq question
    end
    
    it 'marks answer as the best' do
      choose_best_answer
      answer.reload
      expect(answer.best).to be true
    end
  end
end
