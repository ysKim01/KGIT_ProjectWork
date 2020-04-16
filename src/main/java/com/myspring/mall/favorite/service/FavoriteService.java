package com.myspring.mall.favorite.service;

import java.util.List;

import com.myspring.mall.favorite.vo.FavoriteVO;

public interface FavoriteService {

	boolean isFavorite(String userId, String centerCode);

	boolean addFavorite(String userId, String centerCode);

	boolean deleteFavorite(String userId, String centerCode);

	List<FavoriteVO> listFavoriteById(String userId);

}
