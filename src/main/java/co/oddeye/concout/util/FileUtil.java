/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.util;

import java.io.Serializable;
import java.io.File;

/**
 *
 * @author vahan
 */
public class FileUtil implements Serializable {

    public static boolean fileExists(String fileName){
        File f = new File(getWebRootPath() + "WEB-INF/" + fileName);
        return f.exists();
    }

    private static String getWebRootPath() {
        return FileUtil.class.getProtectionDomain().getCodeSource().getLocation().getPath().split("WEB-INF/")[0];
    }
}
