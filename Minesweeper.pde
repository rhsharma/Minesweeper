

import de.bezier.guido.*;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 500);
    textAlign(CENTER,CENTER);
    buttons = new MSButton [20][20];
    bombs  = new ArrayList <MSButton>();
    // make the manager
    Interactive.make( this );
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r, c);
        }
    }
    setBombs();
}

public void setBombs()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[row][col]))
        bombs.add(buttons[row][col]);
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int markedBombs = 0;
    for (int i = 0; i < bombs.size(); i++)
        if (bombs.get(i).isMarked())
            markedBombs+=1;
    if (markedBombs == bombs.size())
        return true;
    return false;
}
public void displayLosingMessage()
{
    if (isWon() == false)
        stroke(255);
        text("Try again!! :)", 200, 450);
}
public void displayWinningMessage()
{
    if (isWon())
        stroke(255);
        text("Yay! You won!!", 200, 450);
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (keyPressed == true) {
            if (marked == true)
                marked = false;
            else if (marked == false)
                marked = true;
        }
        else if (bombs.contains(this))
            displayLosingMessage();
        else if (countBombs(r, c)>0)
            label = " " + countBombs(r, c);
        else
        {
          if(isValid(r, c-1) && !buttons[r][c-1].isClicked())
            buttons[r][c-1].mousePressed();
          if(isValid(r-1, c) && !buttons[r-1][c].isClicked())
            buttons[r-1][c].mousePressed();
          if(isValid(r, c+1) && !buttons[r][c+1].isClicked())
            buttons[r][c+1].mousePressed();
          if(isValid(r+1, c) && !buttons[r+1][c].isClicked())
            buttons[r+1][c].mousePressed();
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)
            return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if (isValid(row+1, col)&& bombs.contains(buttons[row+1][col]))
            numBombs++;
        else if (isValid(row-1, col) && bombs.contains(buttons[row-1][col]))
            numBombs++;
        else if (isValid(row, col+1) && bombs.contains(buttons[row][col+1]))
            numBombs++;
        else if (isValid(row, col-1) && bombs.contains(buttons[row][col-1]))
            numBombs++;
        else if (isValid(row+1, col+1) && bombs.contains(buttons[row+1][col+1]))
            numBombs++;
        else if (isValid(row-1, col-1) && bombs.contains(buttons[row-1][col-1]))
            numBombs++;
        else if (isValid(row-1, col+1) && bombs.contains(buttons[row-1][col+1]))
            numBombs++;
        else if (isValid(row+1, col-1) && bombs.contains(buttons[row+1][col-1]))
            numBombs++;
        return numBombs;
    }
}



