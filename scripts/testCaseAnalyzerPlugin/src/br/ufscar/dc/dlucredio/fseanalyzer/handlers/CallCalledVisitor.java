package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import org.eclipse.jdt.core.IMethod;
import org.eclipse.jdt.core.dom.ASTVisitor;
import org.eclipse.jdt.core.dom.IMethodBinding;
import org.eclipse.jdt.core.dom.MethodDeclaration;
import org.eclipse.jdt.core.dom.MethodInvocation;

public class CallCalledVisitor extends ASTVisitor {
	
	private CallCalledList callCalledList;
	private IMethod invokingMethod;
	
	public CallCalledVisitor() {
		callCalledList = new CallCalledList();
	}
	
	

	public CallCalledList getCallCalledList() {
		return callCalledList;
	}



	@Override
	public boolean visit(MethodDeclaration node) {
		IMethodBinding imb = node.resolveBinding();
		if (imb == null) {
			Constants.LOGGER.severe("Error 17:Method binding for method " + node.getName() + " is null");
		} else {
			invokingMethod = (IMethod) imb.getJavaElement();

			if (invokingMethod == null) {
				Constants.LOGGER.severe("Error 18:Java element for method " + imb.getName() + " is null");
			}
		}
		return super.visit(node);
	}

	@Override
	public void endVisit(MethodDeclaration node) {
		invokingMethod = null;
		super.endVisit(node);
	}

	@Override
	public boolean visit(MethodInvocation node) {
		if(invokingMethod != null) {
			IMethodBinding imb = node.resolveMethodBinding();
			if (imb == null) {
				Constants.LOGGER.severe("Error 19:Method binding for method " + node.getName() + " is null");
			} else {
				IMethod invokedMethod = (IMethod) imb.getJavaElement();

				if (invokedMethod == null) {
					Constants.LOGGER.severe("Error 20:Java element for method " + imb.getName() + " is null");
				} else {
					callCalledList.add(new CallCalled(invokingMethod, invokedMethod));
				}
			}
		}
		return super.visit(node);
	}

}
