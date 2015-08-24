package com.ktxsoftware.kje.editor;

import javax.swing.BoxLayout;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class InfoBar extends JPanel {
	private static final long serialVersionUID = 1L;
	private static InfoBar instance;
	private JLabel label;
	private int tile, x, y;
	
	private InfoBar() {
		setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
		label = new JLabel("Tile: ? X: ? Y: ?");
		add(label);
	}
	
	public static InfoBar getInstance() {
		if (instance == null) instance = new InfoBar();
		return instance;
	}
	
	public void update(int tile) {
		this.tile = tile;
		updateText();
	}
	
	public void update(int x, int y) {
		this.x = x;
		this.y = y;
		updateText();
	}
	
	private void updateText() {
		label.setText("Tile: " + tile + " X: " + x + " Y: " + y);
	}
}
