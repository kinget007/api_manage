package com.yyl.api.util;

import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class FileUtil {
	public static String readAll(String fname) throws FileNotFoundException, IOException {
		String encode = EncodingDetect.getJavaEncode(fname);
		String content = "";
		File file = new File(fname);
		BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), encode));
		String line = null;
		while ((line = reader.readLine()) != null) {
			content += line + "\n";
		}
		reader.close();
		return content;
	}

	public static void writeAll(String fname, String content) {
		try {
			FileWriter write = new FileWriter(fname);
			write.write(content);
			write.flush();
			write.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void makeDir(File dir) {
		if (dir.getParentFile() != null && !dir.getParentFile().exists()) {
			makeDir(dir.getParentFile());
		}
		dir.mkdir();
	}

	public static void createDir(String dir) {
		File file = new File(dir);
		if (!file.exists() && !file.isDirectory()) {
			file.mkdir();
		}
	}

	public static boolean createFile(File file) throws IOException {
		if (!file.exists()) {
			makeDir(file.getParentFile());
		}
		return file.createNewFile();
	}

	public static List<String> getFiles(String dir, String suffix) {
		File baseDir = new File(dir);
		final String suf = suffix;
		List<String> fileList = new ArrayList<String>();
		if (baseDir.isDirectory()) {
			File[] files = baseDir.listFiles(new FilenameFilter() {
				public boolean accept(File dir, String name) {
					return name.endsWith("." + suf);
				}
			});
			for (int i = 0; i < files.length; i++) {
				fileList.add(files[i].getName());
			}
		}
		return fileList;
	}

	public static List<String> getFiles(String dir, String suffix, int sort) {
		List<String> fileList = getFiles(dir, suffix);
		if (sort == 1) {
			Collections.sort(fileList);
			Collections.reverse(fileList);
		} else if (sort == 2) {
			Collections.sort(fileList);
		}
		return fileList;
	}

	public static List<String> getDirs(String dir, int sort) {
		File f = new File(dir);
		List<String> dirs = new ArrayList<String>();
		if (!f.isDirectory()) {
			System.out.println("Directory does not exist！");
		} else {
			File[] t = f.listFiles();
			for (int i = 0; i < t.length; i++) {
				if (t[i].isDirectory()) {
					dirs.add(t[i].getName());
				}
			}
		}
		if (sort == 1) {
			Collections.sort(dirs);
			Collections.reverse(dirs);
		} else if (sort == 2) {
			Collections.sort(dirs);
		}
		return dirs;
	}

//	public static List<String> getReports() {
//		return FileUtil.getDirs("web\\history\\", 1);
//	}
//
//	public static List<String> getLogs() {
//		List<String> reports = getReports();
//		return FileUtil.getFiles("web\\history\\" + reports.get(0) + "\\log", "html", 1);
//	}
}
