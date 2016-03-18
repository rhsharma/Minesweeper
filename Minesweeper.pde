

import de.bezier.guido.*;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private final static int NUM_BOMBS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
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
    for (int i = 0; i <= NUM_BOMBS; i++) {
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if (!bombs.contains(buttons[row][col]))
            bombs.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon()) {
        displayWinningMessage();
    }
    if(isBombPressed()) {
        displayLosingMessage();
    }
}
public boolean isWon()
{
    int markedBombs = 0;
    for (int i = 0; i < bombs.size(); i++)
        if (bombs.get(i).isMarked())
            markedBombs++;
    if (markedBombs == NUM_BOMBS+1)
        return true;
    return false;
}
public boolean isBombPressed()
{
    for (int i = 0; i< bombs.size(); i++)
        if (bombs.get(i).isClicked())
            return true;
    return false;
}
public void displayLosingMessage()
{
    stroke(255);
    for (int r = 0; r< NUM_ROWS; r++) {
        for (int c = 0; c<NUM_COLS; c++)
            if (bombs.contains(buttons[r][c]) && !buttons[r][c].isMarked())
                buttons[r][c].marked = true;
    }
    buttons[10][4].setLabel("T");
    buttons[10][5].setLabel("r");
    buttons[10][6].setLabel("y");
    buttons[10][7].setLabel(" ");
    buttons[10][8].setLabel("a");
    buttons[10][9].setLabel("g");
    buttons[10][10].setLabel("a");
    buttons[10][11].setLabel("i");
    buttons[10][12].setLabel("n");
    buttons[10][13].setLabel("?");
}
public void displayWinningMessage()
{
    buttons[10][4].setLabel("Y");
    buttons[10][5].setLabel("o");
    buttons[10][6].setLabel("u");
    buttons[10][7].setLabel(" ");
    buttons[10][8].setLabel("w");
    buttons[10][9].setLabel("o");
    buttons[10][10].setLabel("n");
    buttons[10][11].setLabel("!");
    buttons[10][12].setLabel("!");
    buttons[10][13].setLabel("!");
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
        if (mouseButton == LEFT)
            clicked = true;
        if (mouseButton == RIGHT)
            marked = !marked;
        else if (countBombs(r, c)>0 && isMarked() == false)
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
        
/*
        if (isValid(r+1, c)&& !buttons[r+1][c].clicked)
            buttons[r+1][c].mousePressed();
        else if (isValid(r-1, c) && !buttons[r-1][c].clicked)
            buttons[r-1][c].mousePressed();
        else if (isValid(r, c+1) && !buttons[r][c+1].clicked)
            buttons[r][c+1].mousePressed();
        else if (isValid(r, c-1) && !buttons[r][c-1].clicked)
            buttons[r][c-1].mousePressed();
        else if (isValid(r+1, c+1) && !buttons[r+1][c+1].clicked)
            buttons[r+1][c+1].mousePressed();
        else if (isValid(r-1, c-1) && !buttons[r-1][c-1].clicked)
            buttons[r-1][c-1].mousePressed();
        else if (isValid(r-1, c+1) && !buttons[r-1][c+1].clicked)
            buttons[r-1][c+1].mousePressed();
        else if (isValid(r+1, c-1) && !buttons[r+1][c-1].clicked)
            buttons[r+1][c-1].mousePressed();
*/
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



