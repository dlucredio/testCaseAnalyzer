package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import java.util.Iterator;
import java.util.List;
import java.util.stream.Stream;

public class Helpers {	
	public static String arrayToString(String[] list, String separator) {
		StringBuilder sb = new StringBuilder();

		for (int i = 0; i < list.length; i++) {
			String s = list[i];
			if (s.contains(separator)) {
				throw new RuntimeException("Error! String "+i+" in CSV file contains separator:" + s);
			}
			sb.append(s);
			if (i < list.length - 1) {
				sb.append(separator);
			}
		}

		return sb.toString();
	}

	public static String iterableToString(Iterable<String> list, String separator) {
		StringBuilder sb = new StringBuilder();

		Iterator<String> iList = list.iterator();
		while (iList.hasNext()) {
			String s = iList.next();
			if (s.contains(separator)) {
				throw new RuntimeException("Error! String in CSV file contains separator:" + s);
			}
			sb.append(s);
			if (iList.hasNext()) {
				sb.append(separator);
			}
		}

		return sb.toString();
	}
	
	public static String streamToString(Stream<String> stream, String separator) {
		StringBuilder sb = new StringBuilder();

		Iterator<String> iStream = stream.iterator();
		while (iStream.hasNext()) {
			String s = iStream.next();
			if (s.contains(separator)) {
				throw new RuntimeException("Error! String in CSV file contains separator:" + s);
			}
			sb.append(s);
			if (iStream.hasNext()) {
				sb.append(separator);
			}
		}

		return sb.toString();
	}	

	public static boolean compareStringEquals(String text, String[] containedText) {
		for (String s : containedText) {
			if (text.equals(s)) {
				return true;
			}
		}
		return false;
	}
	
	public static boolean compareStringsContains(List<String> listOne, List<String> listTwo) {
		for (String a : listOne) {
			for (String ea : listTwo) {
				if (a.contains(ea)) {
					return true;
				}
			}
		}
		return false;
	}
}
