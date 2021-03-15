package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;

public class SampleHandler extends AbstractHandler {

	public Object execute(ExecutionEvent event) throws ExecutionException {
		TestCaseAnalyzer tca = new TestCaseAnalyzer();
		tca.schedule();
		return null;
	}
}
