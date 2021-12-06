package com.example.votesspring.config;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;


@Configuration
@MapperScan(basePackages = {"com.example.votesspring.mapper"}, sqlSessionFactoryRef = "sqlSessionFacotry")
@EnableTransactionManagement
public class MyBatisConfig {

    @Primary
    @Bean(name = "sqlSessionFacotry")
    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource,
                                               ApplicationContext applicationContext) throws Exception {
        org.apache.ibatis.session.Configuration configuration = new org.apache.ibatis.session.Configuration();
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        sqlSessionFactoryBean.setTypeAliasesPackage("com.example.votesspring.domain");
        sqlSessionFactoryBean.setMapperLocations(
                applicationContext.getResource("classpath:mapper/UserMapperRepo.xml")
                ,applicationContext.getResource("classpath:mapper/QuestionMapperRepo.xml")
                ,applicationContext.getResource("classpath:mapper/AnswerMapperRepo.xml")
                ,applicationContext.getResource("classpath:mapper/AnswerHistoryMapperRepo.xml")
                );
        return sqlSessionFactoryBean.getObject();
    }

    @Bean(name = "sqlSessionTemplate")
    public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }

}
