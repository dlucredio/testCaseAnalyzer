package com.dlucredio;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeSet;

import com.dlucredio.Java9Parser.MethodDeclarationContext;

import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Token;

public class EntropyVisitor extends Java9BaseVisitor<Void> {
    Map<String, String> cache;
    CommonTokenStream cts;
    PrintWriter pw;
    String project;
    String testCase;
    String filePath;

    public EntropyVisitor(Map<String, String> cache, CommonTokenStream cts, PrintWriter pw, String project,
            String testCase, String filePath) {
        this.cache = cache;
        this.cts = cts;
        this.pw = pw;
        this.project = project;
        this.testCase = testCase;
        this.filePath = filePath;
    }

    @Override
    public Void visitMethodDeclaration(MethodDeclarationContext ctx) {
        String methodName = ctx.methodHeader().methodDeclarator().identifier().getText();
        int numberOfOperandsAndOperators = 0;
        Set<String> setOfUniqueOperandsOperators = new TreeSet<>();
        Map<String, Integer> termCountMap = new HashMap<>();
        List<Token> tokens = cts.getTokens(ctx.getStart().getTokenIndex(), ctx.getStop().getTokenIndex());
        for (Token t : tokens) {
            if (t.getType() != Java9Lexer.COMMENT && t.getType() != Java9Lexer.LINE_COMMENT && !t.getText().equals(",")
                    && !t.getText().equals(")") && !t.getText().equals("}") && !t.getText().equals("]")) {
                String term = t.getText();
                numberOfOperandsAndOperators++;
                // System.out.println(numberOfOperandsAndOperators+":"+t.getText());
                setOfUniqueOperandsOperators.add(term);
                if (termCountMap.containsKey(term)) {
                    int oldCount = termCountMap.get(term);
                    termCountMap.put(term, oldCount + 1);
                } else {
                    termCountMap.put(term, 1);
                }
            }
        }
        int halsteadLength = numberOfOperandsAndOperators;
        int halsteadVocabulary = setOfUniqueOperandsOperators.size();
        double halsteadVolume = halsteadLength * (Math.log(halsteadVocabulary) / Math.log(2));
        int allTermsCount = halsteadLength;

        System.out.println("Method:" + methodName);
        Set<Entry<String, Integer>> termCountEntrySet = termCountMap.entrySet();
        Map<String, Double> p = new HashMap<>();
        for (Entry<String, Integer> tcEntry : termCountEntrySet) {
            double pValue = (double) tcEntry.getValue() / (double) allTermsCount;
            p.put(tcEntry.getKey(), pValue);
        }

        double entropy = 0.0;
        Set<Entry<String, Double>> pEntrySet = p.entrySet();
        for (Entry<String, Double> pEntry : pEntrySet) {
            double pValue = pEntry.getValue();
            entropy -= pValue * Math.log(pValue) / Math.log(2);
        }

        String cacheKey = project + "$" + filePath + "$" + methodName;
        String cacheEntry = project + "," + filePath + "," + methodName + "," + halsteadLength + ","
                + halsteadVocabulary + "," + halsteadVolume + "," + entropy;
        if (methodName.equals(testCase)) {
            pw.println(cacheEntry);
            pw.flush();
        } else {
            cache.put(cacheKey, cacheEntry);
        }

        return super.visitMethodDeclaration(ctx);
    }

}
