

$(window).on('load',function(){
	
	$('.pubSelectbox .textArea').on('click',function(event){
		var selectList = $(this).next();
		$(this).children('input').focus();
		if(!selectList.hasClass('on')){
			console.log("성공");
			selectList.addClass('on');
		}else{
			selectList.removeClass('on');
		}
	});
	$('.pubSelectbox .textArea input').on('focus',function(){
		 $(this).parent('a').addClass('focus');
	}).on('blur',function(){
		 $(this).parent('a').removeClass('focus');
	});
	$('.pubSelectbox .listArea a').on('click',function(){
		var getText = $(this).text();
		var target = $(this).parent('li').parent('ul').parent('div').prev();
		target.children('input').val(getText);
		target.contents()[0].textContent = getText;
		target.next().removeClass('on');
		return false;
	})
	


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
	 $('.loginArea #userId').focus();
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
 function pubSelectClick(){
	 
 }
