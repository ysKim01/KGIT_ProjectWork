package com.myspring.mall.favorite.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.favorite.dao.FavoriteDAO;
import com.myspring.mall.favorite.vo.FavoriteVO;

@Service("favoriteService")
@Transactional(propagation=Propagation.REQUIRED)
public class FavoriteServiceImpl implements FavoriteService{
	@Autowired
	private FavoriteDAO favoriteDAO;
	
	@Override
	public boolean isFavorite(String userId, String centerCode) {
		boolean result = false;
		
		Map map = new HashMap();
		map.put("userId", userId);
		map.put("centerCode", centerCode);
		int num = favoriteDAO.countFavoriteMatch_IDCODE(map);
		
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}

	@Override
	public boolean addFavorite(String userId, String centerCode) {
		boolean result = false;
		FavoriteVO favorite = new FavoriteVO();
		
		Integer keyNum = favoriteDAO.selectMaxKeyNum() + 1;
		favorite.setKeyNum(keyNum);
		favorite.setUserId(userId);
		favorite.setCenterCode(centerCode);
		
		int num = favoriteDAO.insertFavorite(favorite);
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}

	@Override
	public boolean deleteFavorite(String userId, String centerCode) {
		boolean result = false;
		
		Map map = new HashMap();
		map.put("userId", userId);
		map.put("centerCode", centerCode);
		int num = favoriteDAO.deleteFavorite(map);
		
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}

	@Override
	public List<FavoriteVO> listFavoriteById(String userId) {
		List<FavoriteVO> list = null;
		list = favoriteDAO.listFavoriteById(userId);
		return list;
	}

}
