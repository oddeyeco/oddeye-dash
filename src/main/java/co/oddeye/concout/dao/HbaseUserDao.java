/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.User;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

//import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseUserDao {

//    @Autowired
//    private SessionFactory sessionFactory;

    private Map<UUID, User> users = new HashMap<UUID, User>();

    public void addUser(User user) {
//        sessionFactory.getCurrentSession().save(user);
    }

    public List<User> getAllUsers() {
        return new ArrayList<User>(users.values());
    }

    public User getUserByEmail(String email) {
        return null;
    }

    public User getUserByUUID(UUID email) {
        return null;
    }
}
