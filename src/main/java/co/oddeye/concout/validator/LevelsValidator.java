/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.validator;

import co.oddeye.concout.model.User;
import co.oddeye.core.AlertLevel;
import java.util.Map;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

/**
 *
 * @author vahan
 */
@Component
public class LevelsValidator implements Validator {

    @Override
    public boolean supports(Class<?> type) {
        return AlertLevel.class.isAssignableFrom(type);
    }

    @Override
    public void validate(Object o, Errors errors) {
        User user = (User) o;

        for (Map.Entry<Integer, Map<Integer, Double>> levelEntry : user.getAlertLevels().entrySet()) {
            for (Map.Entry<Integer, Double> level : levelEntry.getValue().entrySet()) {
                ValidationUtils.rejectIfEmptyOrWhitespace(errors, "AlertLevels[" + levelEntry.getKey() + "][" + level.getKey() + "]", "empty.value", "Value must not be empty.");
                

                if (level.getKey()==AlertLevel.ALERT_PARAM_PECENT)
                {
                    if (level.getValue()<0)
                    {
                        errors.rejectValue("AlertLevels[" + levelEntry.getKey() + "][" + level.getKey() + "]", "negativvalue", "Value less than 0.");
                    }
                }
                if (level.getKey()==AlertLevel.ALERT_PARAM_PREDICTPERSENT)
                {
                    if (level.getValue()<0)
                    {
                        errors.rejectValue("AlertLevels[" + levelEntry.getKey() + "][" + level.getKey() + "]", "negativvalue", "Value less than 0.");
                    }
                }                
                if (level.getKey()==AlertLevel.ALERT_PARAM_WEIGTH)
                {
                    if (level.getValue()<0)
                    {
                        errors.rejectValue("AlertLevels[" + levelEntry.getKey() + "][" + level.getKey() + "]", "negativvalue", "Value less than 0.");
                    }
                    if (level.getValue()>16)
                    {
                        errors.rejectValue("AlertLevels[" + levelEntry.getKey() + "][" + level.getKey() + "]", "16value", "Value more than 16.");
                    }                    
                }                                
                if (level.getKey()==AlertLevel.ALERT_PARAM_RECCOUNT)
                {
                    if (level.getValue()<0)
                    {
                        errors.rejectValue("AlertLevels[" + levelEntry.getKey() + "][" + level.getKey() + "]", "negativvalue", "Value less than 0.");
                    }
                    if (level.getValue()>15)
                    {
                        errors.rejectValue("AlertLevels[" + levelEntry.getKey() + "][" + level.getKey() + "]", "10value", "Value more than 15.");
                    }                    
                }                                                
            }
        }

    }

}
