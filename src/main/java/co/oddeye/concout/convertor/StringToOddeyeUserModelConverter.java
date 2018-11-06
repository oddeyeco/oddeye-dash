package co.oddeye.concout.convertor;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;


@Component
public class StringToOddeyeUserModelConverter implements Converter<String, OddeyeUserModel> {

    static final Logger LOGGER = LoggerFactory.getLogger(StringToOddeyeUserModelConverter.class);

    @Autowired
    private HbaseUserDao Userdao;
    @Override
    public OddeyeUserModel convert(String element) {
        if (element.isEmpty()) {
            return null;
        }        
        OddeyeUserModel user = Userdao.getUserByUUID(element);        
        return user;
    }

}
