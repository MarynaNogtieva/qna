require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  
  
  describe 'POST #create' do
    sign_in_user
    context'with valid attributes' do
      it 'should save @answer to DB' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
        .to change(question.answers, :count).by(1)

        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
        .to change(user.answers, :count).by(1)
      end

      it 'should redirect to question#show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to  question_path(assigns(:question))
      end
    end

    context'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer)} }
        .to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context'user is an author' do
      sign_in_user
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, params: {question_id: question, id: answer} }.to change(Answer, :count).by(-1)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context'user is not an author' do
      it 'tries to delete answer' do
        random_user = create(:user)
        somebody_answer = create(:answer, user: random_user, question: question)
        expect { delete :destroy, params: {question_id: question, id: somebody_answer} }.to_not change(Answer, :count)
      end
    end
  end
end
