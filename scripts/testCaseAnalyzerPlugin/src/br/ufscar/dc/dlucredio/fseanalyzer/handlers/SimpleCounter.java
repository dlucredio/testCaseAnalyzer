package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

public class SimpleCounter {
	private int counter;
	
	public SimpleCounter() {
		counter = 0;
	}
	
	public void increment(int amount) {
		counter += amount;
	}
	
	public int getValue() {
		return counter;
	}
}
