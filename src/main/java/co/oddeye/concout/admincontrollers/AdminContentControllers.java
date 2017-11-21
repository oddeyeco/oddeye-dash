/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.SitePage;
import co.oddeye.concout.model.OddeyeUserModel;
import java.util.AbstractMap.SimpleEntry;
import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import javax.servlet.http.HttpServletRequest;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class AdminContentControllers extends GRUDControler {

    public AdminContentControllers() {

        Map<String, String> aa = Collections.unmodifiableMap(Stream.of(
                new SimpleEntry<>("path", "title"),
                new SimpleEntry<>("title", "Title"),
                new SimpleEntry<>("type", "String"))
                .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())));

        AddViewConfig(
                "email", Collections.unmodifiableMap(Stream.of(
                        new SimpleEntry<>("path", "title"),
                        new SimpleEntry<>("title", "Title"),
                        new SimpleEntry<>("type", "String"))
                        .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        ).AddViewConfig("actions",
                Collections.unmodifiableMap(Stream.of(
                        new SimpleEntry<>("path", "actions"),
                        new SimpleEntry<>("title", "Actions"),
                        new SimpleEntry<>("type", "actions"))
                        .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        );

        AddEditConfig("slug", Collections.unmodifiableMap(Stream.of(
                new SimpleEntry<>("path", "slug"),
                new SimpleEntry<>("title", "Slug"),
                new SimpleEntry<>("type", "String"),
                new SimpleEntry<>("required", true))
                .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        ).AddEditConfig(
                "title", Collections.unmodifiableMap(Stream.of(
                        new SimpleEntry<>("path", "title"),
                        new SimpleEntry<>("title", "Display text"),
                        new SimpleEntry<>("type", "String"),
                        new SimpleEntry<>("required", true))
                        .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        ).AddEditConfig(
                "fulltitle", Collections.unmodifiableMap(Stream.of(
                        new SimpleEntry<>("path", "fulltitle"),
                        new SimpleEntry<>("title", "Title"),
                        new SimpleEntry<>("type", "String"),
                        new SimpleEntry<>("required", true))
                        .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        ).AddEditConfig(
                "content", Collections.unmodifiableMap(Stream.of(
                        new SimpleEntry<>("path", "content"),
                        new SimpleEntry<>("title", "Text"),
                        new SimpleEntry<>("type", "Text"),
                        new SimpleEntry<>("rows", 30),
                        new SimpleEntry<>("required", false))
                        .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        ).AddEditConfig(
                "description", Collections.unmodifiableMap(Stream.of(
                        new SimpleEntry<>("path", "description"),
                        new SimpleEntry<>("title", "Description"),
                        new SimpleEntry<>("type", "Text"),
                        new SimpleEntry<>("rows", 5),
                        new SimpleEntry<>("required", false))
                        .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        ).AddEditConfig(
                "keywords", Collections.unmodifiableMap(Stream.of(
                        new SimpleEntry<>("path", "keywords"),
                        new SimpleEntry<>("title", "Keywords"),
                        new SimpleEntry<>("type", "String"),
                        new SimpleEntry<>("required", false))
                        .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        ).AddEditConfig(
                "actions", Collections.unmodifiableMap(Stream.of(
                        new SimpleEntry<>("path", "actions"),
                        new SimpleEntry<>("title", " Actions"),
                        new SimpleEntry<>("type", "actions"))
                        .collect(Collectors.toMap((e) -> e.getKey(), (e) -> e.getValue())))
        );
    }

    @RequestMapping(value = "/pages", method = RequestMethod.GET)
    public String showlist(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }

        map.put("modellist", null);
        map.put("configMap", getViewConfig());
        map.put("body", "adminlist");
        map.put("path", "pages");
        map.put("jspart", "adminjs");
        return "index";
    }

    @RequestMapping(value = "/pages/new", method = RequestMethod.GET)
    public String newpage(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);

            map.put("model", new SitePage());
            map.put("configMap", getEditConfig());
            map.put("modelname", "User");
            map.put("body", "adminnew");
            map.put("jspart", "adminjs");
            map.put("configMap", getEditConfig());
        } else {
            map.put("isAuthentication", false);
        }
        map.put("path", "pages");
        return "index";
    }

    @RequestMapping(value = "/pages/new/", method = RequestMethod.POST)
    public String addpage(@ModelAttribute("model") SitePage sitePage, ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);

            map.put("model", sitePage);
            map.put("configMap", getEditConfig());
            map.put("modelname", "User");
            map.put("body", "adminnew");
            map.put("jspart", "adminjs");
            map.put("configMap", getEditConfig());
        } else {
            map.put("isAuthentication", false);
        }
        map.put("path", "pages");
        return "index";
    }
}
