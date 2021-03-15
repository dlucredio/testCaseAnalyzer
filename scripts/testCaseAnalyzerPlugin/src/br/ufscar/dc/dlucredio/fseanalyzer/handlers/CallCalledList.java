package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.jdt.core.IMethod;

public class CallCalledList {
	List<CallCalled> theList;
	
	public CallCalledList() {
		theList = new ArrayList<>();
	}
	
	public void add(CallCalled cc) {
		theList.add(cc);
	}
	
	public List<IMethod> getAllMethodsCalling(IMethod m) {
		List<IMethod> ret = new ArrayList<>();
		
		for(CallCalled cc: theList) {
			if(JavaModelHelpers.checkIfSameMethod(m, cc.invokedMethod)) {
				ret.add(cc.invokingMethod);
			}
		}
		
		return ret;
	}
}
