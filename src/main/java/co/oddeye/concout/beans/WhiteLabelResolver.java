/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.beans;

import co.oddeye.concout.dao.WhitelabelDao;
import co.oddeye.concout.model.WhitelabelModel;
import java.io.Serializable;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author vahan
 */
public class WhiteLabelResolver implements Serializable {

    @Autowired
    private HttpServletRequest request;

    @Autowired
    private HttpSession session;

    @Autowired
    WhitelabelDao whitelabeldao;    
    
    public String getDomain() {
        return request.getHeader("Host").split(":")[0];
    }
    
    public WhitelabelModel getWhitelabelModel() {
        return whitelabeldao.getByDomain(getDomain());
    }    
}
