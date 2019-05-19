/*
https://www.pixelto.net/px-to-mm-converter
1 inch = 25.4 mm
1 px = 25.4 mm / dpi
25.4 mm = 1px * dpi
1 mm = dpi / 25.4

iphone 6: 326 ppi
*/
int dpi = prompt("Please enter the dpi of your device:\n" +
						 "Enter only the number!\n\n" +
						 "References:\n" + 
						 "iphone 6: 326 dpi\n" + 
						 "Lenovo Thinkpad X1 Carbon: 161 dpi");

float mm = dpi / 25.4;

//line
class Line {
	int x1, x2, y;
	
	Line(int x1, int x2, int y){
		this.x1 = x1;
		this.x2 = x2;
		this.y = y;
	}
}

class Box {
	int x1, x2, y1, y2;
	Line l;
	TargetBoxSize size;
	
	Box(int x1, Line l, TargetBoxSize size){
		this.x1 = x1;
		this.y1 = l.y - (size.height/2);
		this.x2 = size.width;
		this.y2 = size.height;
		this.l = l;
		this.size = size;
		size.increaseTotalCounter();
	}
}

class TargetBoxSize {
	int width, height;
	int originalWidth, originalHeight;
	static int totalCounter = 0;
	int counter;

	TargetBoxSize(width, height){
		this.width = width * mm;
		this.height = height * mm;
		this.counter = 0;
		this.originalWidth = width;
		this.originalHeight = height;
		
	}

	void increaseTotalCounter(){
		this.totalCounter += 1;
	}

	void increaseCounter(){
		this.counter += 1;
	}
}

//globals
ArrayList<float> times = new ArrayList<int>;
ArrayList<TargetBoxSize> sizes = new ArrayList<TargetBoxSize>;
ArrayList<float> distances = new ArrayList<float>;
distances.add(0);
//for js exposure
float[] getTimes(){
	return times.toArray();
}
TargetBoxSizes[] getTargetBoxSizes(){
	return sizes.toArray();
}
float[] getDistances(){
	return distances.toArray();
}
int timer;
globalHeight = window.innerHeight;
globalWidth = window.innerWidth;
l = new Line(0, globalWidth, globalHeight/2);
b = new Box();
int leftPositionLimit = 0;
int rightPositionLimit = globalWidth - (50*mm);
float currentPositionLeft = random(leftPositionLimit, rightPositionLimit);

//allowed sizes in mm width x height
size1 = new TargetBoxSize(10, 5);
size2 = new TargetBoxSize(20, 10);
size3 = new TargetBoxSize(30, 15);
size4 = new TargetBoxSize(40, 20);
size5 = new TargetBoxSize(50, 25);
TargetBoxSize[] allBoxSizes = {size1, size2, size3, size4, size5};

TargetBoxSize getRandomTargetBoxSize(){
	TargetBoxSize tbs = allBoxSizes[int(random(allBoxSizes.length))];
	return tbs;
}

boolean allBoxesShownXTimes(int x){
	for (int i = 0; i < allBoxSizes.length; i++){
		if (allBoxSizes[i].counter != 10){
			return false;
		}
	}
	return true;
}

float calculateNewRandomPosition(){
	while (true){
		float newPositionLeft = random(leftPositionLimit, rightPositionLimit);
		float midOld = b.x1 + (b.x2 / 2);
		float middleNew10 = newPositionLeft + ((5*mm));
		float middleNew20 = newPositionLeft + ((10*mm));
		float middleNew30 = newPositionLeft + ((15*mm));
		float middleNew40 = newPositionLeft + ((20*mm));
		float middleNew50 = newPositionLeft + ((25*mm));
		if (abs(midOld - middleNew10) > 10*mm 
			 && abs(midOld - middleNew20) > 10*mm 
			 && abs(midOld - middleNew30) > 10*mm 
			 && abs(midOld - middleNew40) > 10*mm 
			 && abs(midOld - middleNew50) > 10*mm 
		){
			currentPositionLeft = newPositionLeft;
			return newPositionLeft;
		}
	}
}

void init(Box b){
    background(255);
    stroke(#000000);
		line(l.x1, l.y, l.x2, l.y);
		fill(#FF0000);
		noStroke();
		rect(b.x1, b.y1, b.x2, b.y2);
		timer = millis();
}

void finalScreen(){
	size(globalWidth, globalHeight);
	PFont f;
  f = createFont("Arial",20,true); 
  background(255);
  stroke(175);
  textFont(f);       
  fill(0);
  textAlign(CENTER);
  text("The end. Thank you.", width/2,60); 
}

void setup() {
		noStroke();
    size(globalWidth, globalHeight);
		TargetBoxSize initialBoxSize = getRandomTargetBoxSize();
		b = new Box(currentPositionLeft, l, initialBoxSize);
		init(b);
}

void mousePressed() {
	if (mouseButton == LEFT){
		// collision detection
		if (mouseX > b.x1 && mouseX < (b.x1 + b.x2)
			 && mouseY > b.y1 && mouseY < (b.y1 + b.y2)){
			finishedTimer = millis();
			times.add((finishedTimer - timer) / 1000);
			sizes.add(b.size);
			TargetBoxSize newBoxSize = getRandomTargetBoxSize();
			boolean validNewBox = false;
			while (!validNewBox){
				if (newBoxSize.counter < 10){
					newBoxSize.increaseCounter();
					validNewBox = true;
				} else if (allBoxesShownXTimes(10)) {
					validNewBox = true;
				} else {
					newBoxSize = getRandomTargetBoxSize();
				}
			}
			if (newBoxSize.totalCounter == 50){
				finalScreen();
				
			} else {
				//if 50 is not reached continue
				float middleOld = b.x1 + (b.x2 / 2);
				b = new Box(calculateNewRandomPosition(), l, newBoxSize);
				float middleNew = b.x1 + (b.x2 / 2);
				float distance = abs(middleNew - middleOld);
				distances.add(distance/mm);
				init(b);
			}
		}
	}
}