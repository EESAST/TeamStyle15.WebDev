class TestBattleController < ApplicationController
  skip_before_filter :admin_authorize
  def index
    @users = User.all.sort{|y,x| ((x.test1||=0)+(x.test2||=0)+(x.test3||=0)+(x.test4||=0)+(x.test5||=0)+(x.test6||=0)+(x.test7||=0)+(x.test8||=0)+(x.test9||=0))<=>((y.test1||=0)+(y.test2||=0)+(y.test3||=0)+(y.test4||0)+(y.test5||=0)+(y.test6||=0)+(y.test7||=0)+(y.test8||=0)+(y.test9||=0))}
    @users=@users.paginate(page: params[:page])
  end
end
