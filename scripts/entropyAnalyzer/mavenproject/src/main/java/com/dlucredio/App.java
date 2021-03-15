package com.dlucredio;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTreeListener;
import org.antlr.v4.runtime.tree.TerminalNode;

/**
 * Hello world!
 *
 */
public class App {
    public static void main(String[] args) throws IOException {
        File rootDir = new File(args[0]);
        File inputFile = new File(args[1]);
        File outputFile = new File(args[2]);
        Map<String, String> cache = new HashMap<>();
        try (PrintWriter pw = new PrintWriter(new FileWriter(outputFile))) {
            pw.println(
                    "project,filePath,methodName,noBugFixes,noCommitFixes,noClones,halsteadLength,halsteadVocabulary,halsteadVolume,entropy");
            pw.flush();
            try (BufferedReader br = new BufferedReader(new FileReader(inputFile))) {
                String line = br.readLine();
                int numberOfEntries = 0;
                int numberFound = 0;
                int numberMissing = 0;
                Map<String, File> projectPaths = new HashMap<>();
                while ((line = br.readLine()) != null) {
                    numberOfEntries++;
                    StringTokenizer st = new StringTokenizer(line, ",");
                    String project = st.nextToken();
                    String testCase = st.nextToken();
                    String filePath = st.nextToken();
                    String noBugFixes = st.nextToken();
                    String noCommitFixes = st.nextToken();
                    String noClones = st.nextToken();
                    if (projectPaths.containsKey(project) && projectPaths.get(project) != null) {
                        // already found
                    } else if (projectPaths.containsKey(project) && projectPaths.get(project) == null) {
                        // already found to be missing
                    } else {
                        File f = new File(rootDir + File.separator + project);
                        if (f.exists() && f.isDirectory()) {
                            projectPaths.put(project, f);
                        } else {
                            f = new File(rootDir + File.separator + project + "-core");
                            if (f.exists() && f.isDirectory()) {
                                projectPaths.put(project, f);
                            } else {
                                File subDir = tryToFindInSubDir(rootDir, project, 5);
                                if (subDir != null) {
                                    projectPaths.put(project, subDir);
                                } else {
                                    projectPaths.put(project, null);
                                }
                            }
                        }
                    }
                    File projectDir = projectPaths.get(project);
                    if (projectDir != null) {
                        File fileToParse = new File(projectDir, filePath);
                        if (!fileToParse.exists()) {
                            fileToParse = new File(projectDir.getParent(), filePath);
                        }
                        if (!fileToParse.exists()) {
                            fileToParse = new File(projectDir, project + File.separator + filePath);
                        }
                        if (!fileToParse.exists()) {
                            fileToParse = new File(projectDir.getParent(), project + File.separator + filePath);
                        }
                        if (fileToParse.exists() && fileToParse.isFile()) {
                            numberFound++;
                            parse(numberFound, cache, fileToParse, pw, project, testCase, filePath, noBugFixes,
                                    noCommitFixes, noClones);
                        } else {
                            numberMissing++;
                        }
                    }
                }
                System.out.println(
                        "Total entries " + numberOfEntries + ", found=" + numberFound + ", missing=" + numberMissing);
            }
        }

    }

    private static File tryToFindInSubDir(File rootDir, String project, int level) {
        if (level == 0) {
            return null;
        }
        File ret = null;
        for (File possibleProjectDir : rootDir.listFiles()) {
            if (possibleProjectDir.isDirectory() && possibleProjectDir.getName().equals(project)) {
                return possibleProjectDir;
            } else if (possibleProjectDir.isDirectory() && possibleProjectDir.getName().equals(project + "-core")) {
                return possibleProjectDir;
            } else if (possibleProjectDir.isDirectory()) {
                File ret2 = tryToFindInSubDir(possibleProjectDir, project, level - 1);
                if (ret2 != null) {
                    return ret2;
                }
            }
        }
        return ret;
    }

    private static void parse(int numberFound, Map<String, String> cache, File fileToParse, PrintWriter pw,
            String project, String testCase, String filePath, String noBugFixes, String noCommitFixes,
            String noClones) {
        try {
            String cacheKey = project + "$" + filePath + "$" + testCase;
            String cacheEntry = cache.get(cacheKey);
            if (cacheEntry != null) {
                pw.println(cacheEntry);
                pw.flush();
                return;
            }

            CharStream cs = CharStreams.fromPath(fileToParse.toPath());
            int fileSize = cs.size();
            Java9Lexer lexer = new Java9Lexer(cs);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            Java9Parser parser = new Java9Parser(tokens);
            parser.addParseListener(new ParseTreeListener() {

                @Override
                public void enterEveryRule(ParserRuleContext arg0) {
                    // TODO Auto-generated method stub

                }

                @Override
                public void exitEveryRule(ParserRuleContext arg0) {
                    // TODO Auto-generated method stub

                }

                @Override
                public void visitErrorNode(ErrorNode arg0) {
                    // TODO Auto-generated method stub

                }

                @Override
                public void visitTerminal(TerminalNode arg0) {
                    int percent = (int) (100.0 * arg0.getSymbol().getStopIndex() / fileSize);
                    System.out.println(numberFound + " - " + "Parsing " + percent + "% : " + filePath + " ("
                            + arg0.getSymbol().getStopIndex() + "/" + fileSize + ")");

                }

            });
            Java9Parser.CompilationUnitContext tree = parser.compilationUnit();
            EntropyVisitor v = new EntropyVisitor(cache, tokens, pw, project, testCase, filePath, noBugFixes, noCommitFixes,
                    noClones);
            v.visitCompilationUnit(tree);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
