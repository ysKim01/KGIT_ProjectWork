package com.myspring.mall.admin.center.controller;


import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.fasterxml.jackson.annotation.JsonFormat.Value;
import com.myspring.mall.admin.center.service.AdminCenterService;
import com.myspring.mall.admin.center.vo.AdminCenterFilterVO;
import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;
import com.myspring.mall.common.ControllData;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RestController
@Controller("acenterController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class AdminCenterControllerImpl extends MultiActionController implements AdminCenterController {

	@Autowired
	private AdminCenterService centerService;
	
	private static ControllData conData = new ControllData();
	
	/* ===========================================================================
	 * 카페등록 창 
	 * 
	 ===========================================================================*/

	@RequestMapping(value= {"/centerAddForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView centerAddForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("[info] viewName : " + viewName);
		ModelAndView mav = new ModelAndView(viewName);

		return mav;
	}

	/* ===========================================================================
	 * 스터디룸 등록 
	 *
	 ===========================================================================*/
	@RequestMapping(value= {"/addCenter.do"}, method=RequestMethod.POST)
	public void addCenter(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String nextPage = "/admin/listCenter.do";
		CenterInfoVO center = new CenterInfoVO();
		RoomInfoVO room = new RoomInfoVO();
		CenterContentsVO contents = new CenterContentsVO();
		CenterFacilityVO facility = new CenterFacilityVO();
		
		// centerinfo
		String jsonData = request.getParameter("centerInfo");
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonDATA" + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			// center 등록
			center = JSONinfo(jsonObj);
			System.out.println("등록된 정보 : " + center.toString());
			int result = centerService.addCenter(center);
		}


		//roominfo
		String jsonData1 = request.getParameter("roomInfo");

		if(jsonData1 != null) {
			jsonData1 = URLDecoder.decode(jsonData1,"utf-8");
			JSONObject jsonObj1 = JSONObject.fromObject(jsonData1);

			for (int i = 0; i < jsonObj1.size(); i++) {
				JSONObject jsonObj = (JSONObject) jsonObj1.get(Integer.toString(i));
				System.out.println(jsonObj);			
				//room 등록
				room = JSONroom(jsonObj);
				System.out.println("등록된 정보 : " + room.toString());
				int result = centerService.addRoom(room);
			}
		}

		//Center Facility
		String jsonData2 = request.getParameter("studyFacility");
		if(jsonData2 != null) {
			jsonData2 = URLDecoder.decode(jsonData2,"utf-8");
			JSONObject obj = JSONObject.fromObject(jsonData2);

			//facility 등록
			facility = JSONfacility(obj);
			System.out.println("등록된 정보 : " + facility.toString());
			int result = centerService.addFacility(facility);
		}

		//Center contents
		String jsonData3 = request.getParameter("centerContents");
		if(jsonData3 != null) {
			jsonData3 = URLDecoder.decode(jsonData3,"utf-8");
			JSONObject obj = JSONObject.fromObject(jsonData3);
			System.out.println("contents : " + obj);


			contents.setCenterCode((String)obj.get("centerCode"));
			contents.setCenterPhoto((String)obj.get("centerMain"));
			contents.setCenterIntroduce((String)obj.get("centerIntroduce"));
			contents.setCenterUseInfo((String)obj.get("centerUseInfo"));
			contents.setCenterFareInfo((String)obj.get("centerFareInfo"));

			//roomPhoto 정보 불러오기
			//room 사진 저장 배열
			String[] roomList = new String[10];

			JSONArray foom = (JSONArray)obj.get("foomPhotos");
			for (int i = 0; i < 10; i++) {
				String roomST = "/resources/image/center/"+contents.getCenterCode()+"/";
				if(i<foom.size()) {
					roomST += (String)foom.getString(i);
					System.out.println("room : " + roomST);
				} else {
					roomST = "";
					System.out.println("room : " + roomST);
				}
				roomList[i] = roomST;
			}
			System.out.println("List :" + roomList);

			//roomPhoto 등록
			contents.setRoomPhoto1(roomList[0]);
			contents.setRoomPhoto2(roomList[1]);
			contents.setRoomPhoto3(roomList[2]);
			contents.setRoomPhoto4(roomList[3]);
			contents.setRoomPhoto5(roomList[4]);
			contents.setRoomPhoto6(roomList[5]);
			contents.setRoomPhoto7(roomList[6]);
			contents.setRoomPhoto8(roomList[7]);
			contents.setRoomPhoto9(roomList[8]);
			contents.setRoomPhoto10(roomList[9]);

			System.out.println("등록된 정보 : " + contents.toString());
			int result = centerService.addContents(contents);

		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);

	}

	// 파일 업로드 -----------------------------------------------------
	//--------------------------------------------------------------			
	@RequestMapping(value = "/requestupload2" , method= {RequestMethod.POST, RequestMethod.GET})
	public void requestupload2(MultipartHttpServletRequest mtfRequest, HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("-------------------------fileupload start--------------------------");
		List<MultipartFile> fileList = mtfRequest.getFiles("file");
		System.out.println("listSize :" + fileList.size());
		System.out.println("list : " + fileList);
		String src = mtfRequest.getParameter("src");
		System.out.println("src value : " + src);

		// ( 프로젝트 내부 디렉토리 주소 + src(생성될 폴더이름)
		String path = request.getSession().getServletContext().getRealPath("/resources/image/center/"+ src);
		// 저장 경로
		System.out.println("path :" + path);

		File folder = new File(path);
		
		if (folder.exists()) {
			File[] folder_list = folder.listFiles(); //파일리스트 얻어오기
			if(folder_list.length != 0) {
				for (int j = 0; j < folder_list.length; j++) {
					folder_list[j].delete(); //파일 삭제 
					System.out.println("파일이 삭제되었습니다.");  
				}

			} else if(folder_list.length == 0 && folder.isDirectory()){ 
				folder.delete(); //대상폴더 삭제
				System.out.println("폴더가 삭제되었습니다.");
			}
		}

		try{
			boolean rst = folder.mkdir(); //폴더 생성합니다.
			System.out.println(rst);
			
			System.out.println("폴더가 생성되었습니다.");
			
			for (MultipartFile mt : fileList) {
				String originFileName = mt.getOriginalFilename(); // 원본 파일 명
				long fileSize = mt.getSize(); // 파일 사이즈

				System.out.println("originFileName : " + originFileName);
				System.out.println("fileSize : " + fileSize);

				String safeFile = originFileName;
				try {
					mt.transferTo(new File( path +"\\"+ safeFile));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		
		} catch(Exception e){
			System.out.println("[error] file upload error 발생 ");
			e.getStackTrace();
		}
		System.out.println("-------------------------fileupload end--------------------------");
		String nextPage = "/admin/listCenter.do";
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}

	/* ===========================================================================
	 * 스터디룸 목록 
	 * ---------------------------------------------------------------------------
	 ===========================================================================*/
	
	@RequestMapping(value={"/listCenter.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listCenter(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName"); 
		System.out.println("viewName : "+viewName);

		List<CenterInfoVO> centersList = new ArrayList<CenterInfoVO>();
		AdminCenterFilterVO centerSearch = (AdminCenterFilterVO)request.getAttribute("centerSearch");
//		System.out.println("centerList start~~~~~~~~~~~~~~~~~~");
		if(centerSearch == null) 
			centerSearch = new AdminCenterFilterVO();
		
		centersList = centerService.listCenterByFiltered(centerSearch);
		int maxPage = centerService.getMaxPageByBiltered(centerSearch);
		centerSearch.setMaxPage(maxPage);

//		if(centersList != null && centersList.size() != 0) {
//			for(CenterInfoVO center : centersList) {
//				System.out.println("[toString] start========================");
//				System.out.println(center.toString());
//				System.out.println("[toString] End========================");
//			}
//		}

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("centersList",centersList);
		mav.addObject("centerSearch",centerSearch);
		return mav;
	}
	
	/* ===========================================================================
	 * 카페검색 
	 * ---------------------------------------------------------------------------
	 ===========================================================================*/
	@RequestMapping(value= {"/searchCenter.do"}, method = {RequestMethod.GET,RequestMethod.POST})
	public void searchCenter(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String nextPage = "/admin/listCenter.do";
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);

		AdminCenterFilterVO centerSearch = new AdminCenterFilterVO();
		String jsonData = request.getParameter("centerSearch");

		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			centerSearch = JSONtoSearchInfo(jsonObj);
		}

		request.setAttribute("centerSearch", centerSearch);
		dispatcher.forward(request, response);
	}
	
	/* ===========================================================================
	 * 회원삭제 
	 * ---------------------------------------------------------------------------
	 ===========================================================================*/
	@RequestMapping(value={"/delCenter.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String jsonData = request.getParameter("center");

		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);

			CenterInfoVO center = JSONinfo(jsonObj);
			int result = centerService.delCentersList(center);
		}

		return new ResponseEntity<Boolean>(true, HttpStatus.OK);
	}

	/* ===========================================================================
	 * 8. 다중회원삭제 
	 * ---------------------------------------------------------------------------
	 ===========================================================================*/
	@RequestMapping(value={"/delCentersList.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delMembersList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<CenterInfoVO> centersList = new ArrayList<CenterInfoVO>();

		String jsonData = request.getParameter("list");
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			JSONArray array = JSONArray.fromObject(jsonData);
			for(int i=0;i<array.size();i++) {
				JSONObject obj = (JSONObject)array.get(i);
				CenterInfoVO center = JSONinfo(obj);
				System.out.println(center.toString());
				centersList.add(center);
			}
			int result = centerService.delCentersList(centersList);
			System.out.println("삭제된 열 : " + result);
		}

		return new ResponseEntity<Boolean>(true, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 회원수정 창
	 * ---------------------------------------------------------------------------
	 ===========================================================================*/
	//	@RequestMapping(value={"/modCenterForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	//	public ModelAndView modMemberForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
	//		String viewName = (String)request.getAttribute("viewName"); // 잠시
	//		System.out.println("viewName : "+viewName);
	//		boolean result = true;
	//		
	//		// Member
	//		MemberVO member = null;
	//		String userId = request.getParameter("userId");
	//		if(!conData.isEmpty(userId)) {
	//			member = adminMemberService.getMemberById(userId);
	//			if(member==null) {result = false;}
	//		}else {
	//			result = false;
	//		}
	//		
	//		// SearchInfo
	//		MemberFilterVO searchInfo = new MemberFilterVO();
	//		String jsonDataSearch = request.getParameter("searchInfo");
	//		if(!conData.isEmpty(jsonDataSearch)) {
	//			jsonDataSearch = URLDecoder.decode(jsonDataSearch,"utf-8");
	//			System.out.println(jsonDataSearch);
	//			JSONObject jsonObjSearch = JSONObject.fromObject(jsonDataSearch);
	//			searchInfo = JSONtoMemberFilter(jsonObjSearch);
	//		}else {
	//			result = false;
	//		}
	//		
	//		ModelAndView mav = new ModelAndView(viewName);
	//		mav.addObject("member",member);
	//		mav.addObject("searchInfo",searchInfo);
	//		return mav;
	//	}

	/* ===========================================================================
	 * 회원수정
	 * ---------------------------------------------------------------------------
	 ===========================================================================*/
	//	@RequestMapping(value={"/modCenter.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	//	public ResponseEntity<Boolean> modMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
	//		ResponseEntity<Boolean> resEntity = null;
	//		boolean result = false;
	//		
	//		String jsonData = request.getParameter("center");
	//		System.out.println("json : " + jsonData);
	//		if(jsonData != null) {
	//			jsonData = URLDecoder.decode(jsonData,"utf-8");
	//			//System.out.println(jsonData);
	//			JSONObject jsonObj = JSONObject.fromObject(jsonData);
	//			
	//			CenterInfoVO center = JSONinfo(jsonObj);
	//			if(center != null) {
	//				System.out.println(center.toString());
	//				Integer num = centerService.modCenter(center);
	//				if(num!=null && num>0)
	//					result = true;
	//			}
	//		}
	//		
	//		try {
	//			resEntity = new ResponseEntity<Boolean>(result, HttpStatus.OK);
	//		}catch(Exception e) {
	//			resEntity = new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
	//		}
	//		return resEntity;
	//	}

	
	private String getViewName(HttpServletRequest request)  throws Exception{
		String contextPath = request.getContextPath();
		String uri = (String)request.getAttribute("javax.servlet.include.request_uri");
		
		if (uri == null || uri.trim().equals("")) {
			uri = request.getRequestURI();
		}
		
		int begin = 0;
		if(!((contextPath==null)|| ("".equals(contextPath)))) {
			begin = contextPath.length();
		}
		
		int end;
		if(uri.indexOf(";") != -1) {
			end = uri.indexOf(";");
		} else if (uri.indexOf("?") != -1) {
			end = uri.indexOf("?");
		} else {
			end = uri.length();
		}
		
		String viewName = uri.substring(begin, end);
		if(viewName.indexOf(".") != -1) {
			viewName=viewName.substring(0,viewName.lastIndexOf("."));
		}
		if(viewName.lastIndexOf("/") != -1) {
			viewName=viewName.substring(viewName.lastIndexOf("/",1), viewName.length());
		}
		
		//viewName = viewName.replace("/", "");
		return viewName;
	}

	private CenterInfoVO JSONinfo(JSONObject obj) {
		CenterInfoVO center = new CenterInfoVO();

		center.setCenterCode((String)obj.get("centerCode"));
		center.setCenterName((String)obj.get("centerName"));
		center.setCenterTel((String)obj.get("centerTel"));
		center.setUnitPrice(Integer.parseInt((String)obj.get("unitPrice")));
		center.setOperTimeStart(Integer.parseInt(String.valueOf(obj.get("operTimeStart"))));
		center.setOperTimeEnd(Integer.parseInt(String.valueOf(obj.get("operTimeEnd"))));
		center.setUnitTime(Integer.parseInt(String.valueOf(obj.get("unitTime"))));
		center.setMinTime(Integer.parseInt(String.valueOf(obj.get("minTime"))));
		center.setRatingNum(0);
		center.setRatingScore(0);
		center.setPremiumRate(Integer.parseInt(String.valueOf(obj.get("premiumRate"))));
		center.setSurchageTime(Integer.parseInt(String.valueOf(obj.get("surchageTime"))));
		center.setCenterAdd1((String)obj.get("centerAdd1"));
		center.setCenterAdd2((String)obj.get("centerAdd2"));
		center.setCenterAdd3((String)obj.get("centerAdd3"));

		return center;
	}

	private RoomInfoVO JSONroom(JSONObject obj) {

		RoomInfoVO room = new RoomInfoVO();

		room.setCenterCode((String)obj.get("centerCode"));
		room.setRoomCode((String)obj.get("roomCode"));
		room.setRoomName((String)obj.get("roomName"));
		room.setScale(Integer.parseInt((String)obj.get("scale")));

		return room;
	}

	private CenterFacilityVO JSONfacility(JSONObject obj) {
		CenterFacilityVO facility = new CenterFacilityVO();

		facility.setCenterCode((String)obj.get("centerCode"));
		facility.setLocker(Integer.parseInt(String.valueOf(obj.get("locker"))));
		facility.setNoteBook(Integer.parseInt(String.valueOf(obj.get("projector"))));
		facility.setPrinter(Integer.parseInt(String.valueOf(obj.get("printer"))));
		facility.setProjector(Integer.parseInt(String.valueOf(obj.get("notebook"))));
		facility.setWhiteBoard(Integer.parseInt(String.valueOf(obj.get("whiteboard"))));

		return facility;
	}

	// JSONObject to CenterSearchVO
			private AdminCenterFilterVO JSONtoSearchInfo(JSONObject obj) {
				AdminCenterFilterVO info = new AdminCenterFilterVO();

				info.setSearchFilter((String)obj.get("searchFilter"));
				info.setSearchContents((String)obj.get("searchContents"));
				info.setPage(conData.StringtoInteger((String)obj.get("page")));
				
				return info;
			}

}