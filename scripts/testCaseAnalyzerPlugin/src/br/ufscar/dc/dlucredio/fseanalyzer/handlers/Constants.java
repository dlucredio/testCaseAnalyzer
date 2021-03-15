package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import java.io.File;
import java.util.logging.Logger;

public class Constants {
	/*
	 * Next error code: 28
	 */	
	/**
	 * When DEBUG_MODE = true, only some projects will be analyzed.
	 * Variable TEST_PROJECT_PREFIX defines which ones.
	 * Otherwise, all projects from input folder will be analyzed.
	 * This is useful for quick testing, because analyzing all projects takes a long time.
	 */
	public static boolean DEBUG_MODE = true;
	
	/**
	 * These are the projects that will be analyzed when DEBUG_MODE = true.
	 * Only those folders with name starting with TEST_PROJECT_PREFIX will be analyzed.
	 */
	public final static String TEST_PROJECT_PREFIX = "atestproject2";

	/**
	 * When COVERAGE_MODE = true, scripts for executing each individual test case
	 * will be generated. These scripts can be used to collect code coverage for
	 * each individual test case.
	 * If COVERAGE_MODE = false and PARSE_TEST_CASE_MODE = false nothing is done!
	 * Choose one, or both.
	 */
	public static boolean COVERAGE_MODE = false;

	/** 
	 * When PARSE_TEST_CASE_MODE = true, each test case will be parsed and analyzed.
	 * If COVERAGE_MODE = false and PARSE_TEST_CASE_MODE = false nothing is done!
	 * Choose one, or both.
	 */
	public static boolean PARSE_TEST_CASE_MODE = true;

	public final static Logger LOGGER = Logger.getLogger(Constants.class.getName());

	/** 
	 * Configures where all files will be saved 
	 */
	public final static File OUTPUT_FOLDER = new File("/home/daniel/Desktop/out");

	/** 
	 * Configures where all projects to be analyzed are located
	 */
	public final static File ROOT_FOLDER = new File("/home/daniel/GitProjectsFSE2");


	public final static String[] JUNIT_TEST_CASE_ANNOTATIONS = { "org.junit.Test", "org.junit.jupiter.api.Test",
			"org.junit.jupiter.api.RepeatedTest", "org.junit.jupiter.api.ParameterizedTest",
			"org.junit.jupiter.api.TestFactory", "org.junit.jupiter.api.TestTemplate" };
	public final static String[] JUNIT_ASSERTIONS = { "org.junit.jupiter.api.Assertions",
			"org.junit.Assert",
			"org.assertj.core.api.Assertions",
			"org.assertj.core.api.AssertionsForClassTypes",
			"org.assertj.core.api.AssertionsForInterfaceTypes", 
			"org.assertj.core.api.BDDAssertions",
			"com.google.common.truth.Truth",
			"org.hamcrest.MatcherAssert",
			};
	public final static int MAX_RECURSIVE_CALLS = 5;
	public final static String SECONDARY_SEPARATOR = "|";
	public static final String JUNIT4_TEST_ANNOTATION = "org.junit.Test";
	public static final String JUNIT4_EXPECTS_ANNOTATION = "expected";
	

}
