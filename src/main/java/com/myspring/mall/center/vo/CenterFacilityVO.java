package com.myspring.mall.center.vo;

import org.springframework.stereotype.Component;

@Component("CenterFacilityVO")
public class CenterFacilityVO {
	private String centerCode;
	private int locker;
	private int projector;
	private int printer;
	private int noteBook;
	private int whiteBoard;
	
	// Getter & Setter
	public String getCenterCode() {
		return centerCode;
	}
	public void setCenterCode(String centerCode) {
		this.centerCode = centerCode;
	}
	public int getLocker() {
		return locker;
	}
	public void setLocker(int locker) {
		this.locker = locker;
	}
	public int getProjector() {
		return projector;
	}
	public void setProjector(int projector) {
		this.projector = projector;
	}
	public int getPrinter() {
		return printer;
	}
	public void setPrinter(int printer) {
		this.printer = printer;
	}
	public int getNoteBook() {
		return noteBook;
	}
	public void setNoteBook(int noteBook) {
		this.noteBook = noteBook;
	}
	public int getWhiteBoard() {
		return whiteBoard;
	}
	public void setWhiteBoard(int whiteBoard) {
		this.whiteBoard = whiteBoard;
	}
	
	public String toString() {
		String out = "";
			out +=	"centerCode : "	+	centerCode	+	"\n";
			out +=	"locker : "	+	locker	+	"\n";
			out +=	"projector : "	+	projector	+	"\n";
			out +=	"printer : "	+	printer	+	"\n";
			out +=	"noteBook : "	+	noteBook	+	"\n";
			out +=	"whiteBoard : "	+	whiteBoard	+	"\n";
			
		return out;
	}
	
}
