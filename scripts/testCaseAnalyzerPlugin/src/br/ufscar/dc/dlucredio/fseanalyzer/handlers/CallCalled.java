package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import org.eclipse.jdt.core.IMethod;

public class CallCalled {
	public IMethod invokingMethod, invokedMethod;

	public CallCalled(IMethod invokingMethod, IMethod invokedMethod) {
		super();
		this.invokingMethod = invokingMethod;
		this.invokedMethod = invokedMethod;
	}
	
	
}
