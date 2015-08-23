package com.ktxsoftware.kje.editor;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

public class Sprite {
	private Image img;
	public int index;
	public int width;
	public int height;
	public boolean selected = false;
	
	public Sprite(String imagename, int index) {
		try {
			this.index = index;
			img = ImageIO.read(new File(imagename));
			this.width = img.getWidth(null);
			this.height = img.getHeight(null);
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void paint(Graphics g, int x, int y, boolean hovering, boolean inlevel) {
		g.drawImage(img, x, y, x + width, y + height, 0, 0, width, height, null);
		if (inlevel) return;
		if (selected) {
			g.setColor(new Color(0, 0.5f, 0, 0.5f));
			g.fillRect(x, y, width, height);
		}
		else if (hovering) {
			g.setColor(new Color(1, 0, 0, 0.5f));
			g.fillRect(x, y, width, height);
		}
	}
}
