# encoding: utf-8

class AppTestsController < ApplicationController
  before_filter :authorize_user!,:except => [:register,:update,:getUserInfo,:saveTestScore,:getTestScore,:getTestHist,:login,:getGameScore,:saveGameScore]

  def search
    @action='/app_tests/0/search'
    @key=params[:key]

    @app_tests = AppTest.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @app_tests =@app_tests.where("name like '%#{@key}%'")
    end
    render 'app_tests/index'
  end

  def index
    @action='/app_tests/0/search'

    @app_tests = AppTest.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @app_tests }
    end
  end

  def changePwd
    redirect_to "/lab_user/modify_pass"
  end

  def forgot_pass
    render :layout => "home"
  end

  def register
   redirect_to "/lab_users/new"
  end
#POST
  def update
    result = 9999
    #updateUserInfo begin
    if params[:userId]
      @lab_user = LabUser.find(params[:userId])
      if @lab_user.update_attributes(params[:lab_user])
        result =0
        return render :text=>{ :code => result }.to_json
      else
        return render :text=>{ :code => result }.to_json
      end
    end
    #updateUserInfo end

    #saveTestScore begin
   if params[:app_test]
       params[:app_test].merge!(:test_type=>0)
       @app_test = AppTest.new(params[:app_test])
       if @app_test.save
         result =0
         return render :text=>{ :code => result }.to_json
       else
         return render :text=>{ :code => result }.to_json
       end
   end
   #saveTestScore end

 # rescue
 #   return render :text=>{ :code => result }.to_json
  end

  # POST
  def login
    result = 9999

    @user = LabUser.find_by_account(params[:lab_user][:account])

    if @user.blank?
      result = 200 # "用户不存在."
      return render :text=>{ :code => result }.to_json
    end

    if @user.password != Digest::MD5.hexdigest(params[:lab_user][:password])
      result = 201 #"用户名或者密码不正确."
      return render :text=>{ :code => result }.to_json
    else
      score = 0
      @app_test=AppTest.where(:user_id=>@user.id).select("SUM(score) as score")
      .group(:user_id).order(created_at: :desc).first
      if @app_test
        score=@app_test.score
      end
      result = 0
      render :text => { :code => result,:userInfo => { :userId => @user.id,:name=>@user.name,:age=>@user.age,:sex=>@user.sex,:school=>@user.school,:score=>score} }.to_json
    end
  rescue
    return render :text=>{ :code => result }.to_json
  end

  def getUserInfo
    @user = LabUser.find_by_id(params[:userId])

    if @user.blank?
      result = 200 # "用户不存在."
      return render :text=>{ :code => result }.to_json
    else
      result = 0
      score = 0

      @app_test=AppTest.where(:user_id=>params[:userId]).select("SUM(score) as score")
      .group(:user_id).order(created_at: :desc).first
      if @app_test
        score=@app_test.score
      end

      render :text => { :code => result,:userInfo => {:name=>@user.name,:age=>@user.age,:sex=>@user.sex,:school=>@user.school,:score=>score} }.to_json
    end
  rescue
    result = 9999
    return render :text=>{ :code => result }.to_json
  end

  # POST
  def saveTestScore

  end

  # POST
  def saveGameScore
   #return render :text=>params[:app_test].to_s
    result = 9999

    if params[:app_test]
      params[:app_test].merge!(:test_type=>1)
      @app_test = AppTest.new(params[:app_test])
      if @app_test.save
        result =0
        return render :text=>{ :code => result }.to_json
      else
        return render :text=>{ :code => result }.to_json
      end
    end
  #rescue
 #   return render :text=>{ :code => result }.to_json
  end

  def getGameScore
    @app_test = AppTest.where(:user_id=>params[:userId],:class_id=>params[:gameId],:test_type=>1).order(created_at: :desc).first
    result =9999
    if @app_test.blank?
      # "用户不存在."
      return render :text=>{ :code => result }.to_json
    else
      result = 0
      render :text => { :code => result,:score=>@app_test.score}.to_json
    end
    # rescue
    #   return render :text=>{ :code => result }.to_json
  end

  def getTestScore
    @app_test = AppTest.where(:user_id=>params[:userId],:class_id=>params[:classId],:test_type=>1).order(created_at: :desc).first
    result =9999
    if @app_test.blank?
      # "用户不存在."
      return render :text=>{ :code => result }.to_json
    else
      result = 0
      render :text => { :code => result,:score=>@app_test.score}.to_json
    end
 # rescue
 #   return render :text=>{ :code => result }.to_json
  end

  def getTestHist

    @app_test = AppTest.select("class_id,date_format(created_at,'%Y-%m-%d %h:%I') as time,score")
    .where(:user_id=>params[:userId],:class_id=>params[:classId],:test_type=>0)
    result = 9999
    if @app_test.blank?
      return render :text=>{ :code => result }.to_json

    else
      topic = ["人体奥秘","八大行星","模拟法庭","信息检索"]
  
      testlist = @app_test.to_json(:only =>[:class_id,:time,:score])
      #testlist=@app_test.to_json(:only =>[:class_id,:created_at,:score])
      result = 0
      render :text => {:code=> result,:testlist=> testlist}.to_json .gsub('\\', '') .gsub('"testlist":"[{', '"testlist":[{').gsub('"}]"}','"}]}')
      #{"code:0", "testlist":[{"topic":"水星游戏测","time":"2014-10-12", "score":"50"},{"topic":"水 星游戏测2","time":"2014-10-14", "score":"50"}]
    end
 # rescue
 #   return render :text=>{ :code => result }.to_json
  end

end
