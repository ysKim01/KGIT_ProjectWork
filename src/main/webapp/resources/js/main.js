

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
	
	$('.designCheck > input').on('click',function(){
		if($(this).prop('checked')){
			$(this).next().addClass('check');
		}else if(!$(this).prop('checked')){
			$(this).next().removeClass('check');
		}
	})

	const seoul = ['강북구','강동구','강남구','강서구','관악구','광진구','구로구','금천구','노원구','도봉구','동대문구','동작구','마포구','서대문구','서초구','성동구','성북구','송파구','양천구','영등포구','용산구','은평구','종로구','중구','중랑구'];
	const gg = ['연천','동두천','포천','양주','파주','김포','고양','구리','남양주','의정부','가평','하남','성남','양평','과천','광명','부천','안양','시흥','안산','군포','화성','수원','오산','평택','안성','용인','이천','여주'];
	 // 경기
	const gw = ['철원군','화천군','양구군','춘천시','인제군','고성군','속초시','양양군','홍천군','평창군','횡성군','원주시','영월군','정선군','동해시','강릉시','태백시','삼척시'];
	// 강원
	const ksb = ['문경','예천','상주','김천','구미','성주','고령','칠곡','군위','의성','안동','영천','청송','포항','경산','청도','경주','영양','봉화','울진','울릉도','독도'];
	// 경상북도
	const ksn = ['거창군','함앙군','산청군','하동군','남해군','사천시','진주시','의령군','합천군','창녕군','함안군','창원시','통영서','거제시','김해시','양산시','밀양시'];
	// 경상남도
	const jrb = ['군산시','익산시','완주군','진안군','부주군','김제시','전주시','장수군','임살군','정읍시','부안군','고창군','순창군','남원시'];
	// 전라북도
	const jrn = ['영광군','장성군','담양군','곡성군','구례군','함평군','나주시','화순군','순천시','광양시','여수시','무안군','목포시','영암군','장흥군','보성군','고흥군','강진군','해남군','진도군','신안군','완도군'];
	// 전라남도
	const dj = ['유성구','서구','중구','동구','대덕구'];
	// 대전
	const dg = ['북구','동구','서구','중구','남구','수성구','달서구','달성군'];
	// 대구
	const bs = ['강서구','사하구','사상구','북구','금정구','기장군','동래구','연제구','해운대구','수영구','부산진구','서구','중구','동구','영도구','남구'];
	// 부산
	const chn = ['태안군','서산시','당진시','홍성군','보령시','예산군','청양군','부여군','서천군','공주시','논산시','계룡시','금산군','아산시','천안시서북구','천안시동남구'];
	// 충청남도
	const chb = ['제천시','단양군','충주시','괴산군','음성군','진천군','청주시','보은군','옥천군','영동군','증편군'];
	// 충청북도
	const jj = ['제주시','서귀포시','서제주시','동제주시'];
	
	// 강원
	//경기 강원 경상북 경상남 전라북, 전라남, 대전, 대구, 부산, 충청남, 충청북, 제주시
	var target = $('.addr2');
	var items = '';
	for(var i=0; i<seoul.length; i++){
		items += '<option value="'+seoul[i]+'" name="'+seoul[i]+'">'+seoul[i]+'</option>';
	}
	target.html(items);
	
	$('.addr1').on('change',function(){
		var getText = $(this).val();
		var target = $('.addr2');
		var items = '';
		switch (getText) {
		case "서울":
			for(var i=0; i<seoul.length; i++){
				items += '<option value="'+seoul[i]+'"name="'+seoul[i]+'">'+seoul[i]+'</option>';
			}
			target.html(items);
			break;
		case "강원":
			for(var i=0; i<gw.length; i++){
				items += '<option value="'+gw[i]+'"name="'+gw[i]+'">'+gw[i]+'</option>';
			}
			target.html(items);
			break;
		case "경기":
			for(var i=0; i<gg.length; i++){
				items += '<option value="'+gg[i]+'"name="'+gg[i]+'">'+gg[i]+'</option>';
			}
			target.html(items);
			break;
		case "경북":
			for(var i=0; i<ksb.length; i++){
				items += '<option value="'+ksb[i]+'" name="'+ksb[i]+'">'+ksb[i]+'</option>';
			}
			target.html(items);
			break;
		case "경남":
			for(var i=0; i<ksn.length; i++){
				items += '<option value="'+ksn[i]+'" name="'+ksn[i]+'">'+ksn[i]+'</option>';
			}
			target.html(items);
			break;
		case "전북":
			for(var i=0; i<jrb.length; i++){
				items += '<option value="'+jrb[i]+'" name="'+jrb[i]+'">'+jrb[i]+'</option>';
			}
			target.html(items);
			break;
		case "전남":
			for(var i=0; i<jrn.length; i++){
				items += '<option value="'+jrn[i]+'" name="'+jrn[i]+'">'+jrn[i]+'</option>';
			}
			target.html(items);
			break;
		case "대전":
			for(var i=0; i<dj.length; i++){
				items += '<option value="'+dj[i]+'" name="'+dj[i]+'">'+dj[i]+'</option>';
			}
			target.html(items);
			break;
		case "대구":
			for(var i=0; i<dg.length; i++){
				items += '<option value="'+dg[i]+'" name="'+dg[i]+'">'+dg[i]+'</option>';
			}
			target.html(items);
			break;
		case "부산":
			for(var i=0; i<bs.length; i++){
				items += '<option value="'+bs[i]+'" name="'+bs[i]+'">'+bs[i]+'</option>';
			}
			target.html(items);
			break;
		case "충북":
			for(var i=0; i<chb.length; i++){
				items += '<option value="'+chb[i]+'" name="'+chb[i]+'">'+chb[i]+'</option>';
			}
			target.html(items);
			break;
		case "충남":
			for(var i=0; i<chn.length; i++){
				items += '<option value="'+chn[i]+'" name="'+chn[i]+'">'+chn[i]+'</option>';
			}
			target.html(items);
			break;
		case "제주특별자치도":
			for(var i=0; i<jj.length; i++){
				items += '<option value="'+jj[i]+'" name="'+jj[i]+'">'+jj[i]+'</option>';
			}
			target.html(items);
			break;
			
		default:
			break;
		}
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
	
	setHtml += "</ul><a class='joinMem' href='/mall/member/addMemberForm.do'>회원가입</a></div></form></div></div>"
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
