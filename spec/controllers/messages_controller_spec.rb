require 'rails_helper'

describe MessagesController do
  let(:group) { create(:group) }
  let(:user) { create(:user) }


  describe '#index' do

    context 'log in' do
      before do
        login user
        get :index, params: { group_id: group.id }
        #ログインしている場合,アクション内で定義しているインスタンス変数があるか
      end

      it 'assigns @message' do
        expect(assigns(:message)).to be_a_new(Message)
        #インスタンス変数に代入されたオブジェクトは、コントローラのassigns メソッド経由で参照できます。
        #@messageを参照したい場合、assigns(:message)と記述することができます。
        #@messageはMessage.newで定義された新しいMessageクラスのインスタンスです。
        #be_a_newマッチャを利用することで、 対象が引数で指定したクラスの
        #インスタンスかつ未保存のレコードであるかどうか確かめることができます。
        #今回の場合は、assigns(:message)がMessageクラスのインスタンスかつ未保存かどうかをチェックしています。
      end

      it 'assigns @group' do
        expect(assigns(:group)).to eq group
        #@groupはeqマッチャを利用してassigns(:group)と
        #groupが同一であることを確かめることでテストできます。
      end

      it 'renders index' do
        expect(response).to render_template :index
        #expectの引数にresponseを渡しています。
        #responseは、example内でリクエストが行われた後の
        #遷移先のビューの情報を持つインスタンスです。
        #render_templateマッチャは引数にアクション名を取り、
        #引数で指定されたアクションがリクエストされた時に自動的に遷移するビューを返します。
        #この二つを合わせることによって、example内でリクエストが行われた時の遷移先のビューが、
        #indexアクションのビューと同じかどうか確かめることができます
      end
    end

    context 'not log in' do
      before do
        get :index, params: { group_id: group.id }
        #ログインしていない場合のテストを記述
      end

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
        #redirect_toマッチャは引数にとったプレフィックスにリダイレクトした際の情報を返すマッチャです。
        #今回の場合は、非ログイン時にmessagesコントローラのindexアクションを動かすリクエストが行われた際に、
        #ログイン画面にリダイレクトするかどうかを確かめる記述になっています。
      end
    end
  end

  describe '#create' do
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

    context 'log in' do
      before do
        login user
        #ログインしているかつ、保存に成功した場合
      end

      context 'can save' do
        subject {
          post :create,
          params: params
          #メッセージの保存に成功した場合のテスト
        }

        it 'count up message' do
          expect{ subject }.to change(Message, :count).by(1)
          #メッセージの保存に失敗した場合のテストを記述
          #expectの引数として、subjectを定義して渡しています。
          #expectの引数が長くなってしまう際は、このようにして記述を切り出すことができます。
          #このエクスペクテーションは、
          #「postメソッドでcreateアクションを擬似的にリクエストをした結果」という意味になります。

          #createアクションのテストを行う際にはchangeマッチャを利用することができます。
          #changeマッチャは引数が変化したかどうかを確かめるために利用できるマッチャです。
          #change(Message, :count).by(1)と記述することによって、
          #Messageモデルのレコードの総数が1個増えたかどうかを確かめることができます。
          #保存に成功した際にはレコード数が必ず1個増えるため、このようなテストとなります
        end

        it 'redirects to group_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      context 'can not save' do
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }
        #invalid_paramsを定義する際に、attributes_for(:message)の引数に、
        #content: nil, image: nilと記述しています。
        #擬似的にcreateアクションをリクエストする際にinvalid_paramsを引数として渡してあげることによって、
        #意図的にメッセージの保存に失敗する場合を再現することができます。

        subject {
          post :create,
          params: invalid_params
        }

        it 'does not count up' do
          expect{ subject }.not_to change(Message, :count)
          #Rspecで「〜であること」を期待する場合にはtoを使用しますが、
          #「〜でないこと」を期待する場合にはnot_toを使用できます。
          #not_to change(Message, :count)と記述することによって、
          #「Messageモデルのレコード数が変化しないこと ≒ 保存に失敗したこと」を確かめることができます。
        end

        it 'renders index' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    context 'not log in' do

      it 'redirects to new_user_session_path' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
        #ログインしていない場合にcreateアクションをリクエストした際は、ログイン画面へとリダイレクトします。
        #redirect_toマッチャの引数に、new_user_session_pathを取ることで、
        #ログイン画面へとリダイレクトしているかどうかを確かめることができます。
      end
    end
  end
end