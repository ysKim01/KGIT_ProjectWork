

<<<<<<< HEAD

$(window).on('load',function(){

})
function windowClose(){
    window.close();
    self.close();
}
=======
$(window).on('load',function(){

})
function windowClose(){
    window.close();
    self.close();
}



// =============================== //
// ==========Login Area ========== //
//================================ //

function activeLogon(){
		
	var setHtml = "<div class='screenWrap'><div class='loginFormWrap'><form class='loginForm' name='frmlogin' method='post' action='${contextpath}/member/login.do'><div class='loginArea'><h3 class='loginTitle'>로그인</h3><ul>";
	// id 		
	setHtml += "<li><dl><dt><strong><label for='userId'>아이디</label></strong></dt><dd><span><input placeholder='아이디'type='text' name='userId' id='userId'></span></dd></li>";
	//password
	setHtml += "<li><dl><dt><strong><label for='userPw'>비밀번호</label></strong></dt><dd><span><input placeholder='비밀번호'type='password' name='userPw' id='userPw'></span></dd></li>";
	//loginBtn
	setHtml += "<li class='login_btn'><span><input type='button' value='로그인' onclick='login()'></span></li>";
	
	setHtml += "</ul><a class='joinMem' href='/mall/member/membershipForm.do'>회원가입</a></div></form></div></div>"
	 $('body').append(setHtml);
	 loginActive();
 }
 function loginActive(){
     $('.screenWrap').on('click',function(){
        
         $('.screenWrap').remove();
     })
     $('.loginArea').on('click',function(){
        event.stopPropagation();
     })

     $('.loginArea input[type=password').keydown(function(event){
         if(event.keyCode == '13'){
             login();
         }
     })
 }
>>>>>>> branch 'master' of https://github.com/ysKim01/KGIT_ProjectWork
