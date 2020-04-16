package com.myspring.mall.favorite.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.favorite.vo.FavoriteVO;

@Repository("favoriteDAO")
public class FavoriteDAOImpl implements FavoriteDAO{
	@Autowired
	private SqlSession sqlSession;
	
	
	@Override
	public int countFavoriteMatch_IDCODE(Map map) {
		int result = 0;
		result = sqlSession.selectOne("mapper.favorite.countFavoriteMatch_IDCODE", map);
		return result;
	}

	@Override
	public int selectMaxKeyNum() {
		Integer result = 0;
		result = sqlSession.selectOne("mapper.favorite.selectMaxKeyNum");
		if(result == null) {
			result = 0;
		}
		return result;
	}

	@Override
	public int insertFavorite(FavoriteVO favorite) {
		int result = 0;
		result = sqlSession.insert("mapper.favorite.insertFavorite", favorite);
		return result;
	}

	@Override
	public int deleteFavorite(Map map) {
		int result = 0;
		result = sqlSession.delete("mapper.favorite.deleteFavorite", map);
		return result;
	}

	@Override
	public List<FavoriteVO> listFavoriteById(String userId) {
		List<FavoriteVO> list = null;
		list = sqlSession.selectList("mapper.favorite.listFavoriteById", userId);
		return list;
	}

}
