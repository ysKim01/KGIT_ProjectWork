$(function(){
	var _isLogOn=document.getElementById("logon");
	var isLogOn=_isLogOn.value;
	var pageCover = document.createElement('div');
	pageCover.setAttribute('id','pageCover');
	pageCover.style.position ='absolute';
	pageCover.style.width = '100%';
	pageCover.style.height = '100%';
	pageCover.style.background = '#fff';
	pageCover.style.top = 0;
	pageCover.style.left = 0;
	pageCover.style.zIndex = 99999999999;
	if(isLogOn=="false" || isLogOn=='' ){
		document.body.appendChild(pageCover);
		document.body.style.overflow = 'hidden';
		window.location.href="/mall/main.do"
		alert('로그인이 필요한 페이지입니다.');
		
		
		setTimeout(function(){
			var target = document.getElementById('pageCover');
			console.log(target);
			target.remove();
			document.style.overflow = 'auto';
		}, 3000);
		
		return;
	}
	
})
function clearCover(){
	
}