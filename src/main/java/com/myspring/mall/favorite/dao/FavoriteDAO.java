package com.myspring.mall.favorite.dao;

import java.util.List;
import java.util.Map;

import com.myspring.mall.favorite.vo.FavoriteVO;

public interface FavoriteDAO {

	int countFavoriteMatch_IDCODE(Map map);

	int selectMaxKeyNum();

	int insertFavorite(FavoriteVO favorite);

	int deleteFavorite(Map map);

	List<FavoriteVO> listFavoriteById(String userId);

}
