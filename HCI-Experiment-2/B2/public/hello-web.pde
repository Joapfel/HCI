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

class Box {
	int x1, x2, y1, y2;
	TargetBoxSize size;
	
	Box(int x1, int y1, TargetBoxSize size){
		this.x1 = x1;
		this.y1 = y1;
		this.x2 = size.width;
		this.y2 = size.height;
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
ArrayList<float> distancesWidth = new ArrayList<float>;
ArrayList<float> distancesHeight = new ArrayList<float>;
distancesWidth.add(0);
distancesHeight.add(0);
//for js exposure
float[] getTimes(){
	return times.toArray();
}
TargetBoxSizes[] getTargetBoxSizes(){
	return sizes.toArray();
}
float[] getDistancesWidth(){
	return distancesWidth.toArray();
}
float[] getDistancesHeight(){
	return distancesHeight.toArray();
}
int timer;
globalHeight = window.innerHeight;
globalWidth = window.innerWidth;
b = new Box();
int leftPositionLimit = 0;
int rightPositionLimit = globalWidth - (50*mm);
int upPositionLimit = 0;
int downPositionLimit = globalHeight - (25*mm);
float currentHorizontalPositionLeft = random(leftPositionLimit, rightPositionLimit);
float currentVerticalPositionUp = random(upPositionLimit, downPositionLimit);

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

float calculateNewRandomHorizontalPosition(){
	while (true){
		float newHorizontalPosition = random(leftPositionLimit, rightPositionLimit);
		float midOld = b.x1 + (b.x2 / 2);
		float middleNew10 = newHorizontalPosition + ((5*mm));
		float middleNew20 = newHorizontalPosition + ((10*mm));
		float middleNew30 = newHorizontalPosition + ((15*mm));
		float middleNew40 = newHorizontalPosition + ((20*mm));
		float middleNew50 = newHorizontalPosition + ((25*mm));
		if (
			 abs(midOld - middleNew10) > 10*mm 
			 && abs(midOld - middleNew20) > 10*mm 
			 && abs(midOld - middleNew30) > 10*mm 
			 && abs(midOld - middleNew40) > 10*mm 
			 && abs(midOld - middleNew50) > 10*mm 
		){
			
			currentHorizontalPositionLeft = newHorizontalPosition;
			return newHorizontalPosition;
		}
	}
}

float calculateNewRandomVerticalPosition(){
	while (true){
		float newVerticalPosition = random(upPositionLimit, downPositionLimit);
		float midOld = b.y1 + (b.y2 / 2);
		float middleNew10 = newVerticalPosition + ((2.5*mm));
		float middleNew20 = newVerticalPosition + ((5*mm));
		float middleNew30 = newVerticalPosition + ((7.5*mm));
		float middleNew40 = newVerticalPosition + ((10*mm));
		float middleNew50 = newVerticalPosition + ((12.5*mm));
		if (
			 abs(midOld - middleNew10) > 10*mm 
			 //&& abs(midOld - middleNew20) > 10*mm 
			 //&& abs(midOld - middleNew30) > 10*mm 
			 //&& abs(midOld - middleNew40) > 10*mm 
			 //&& abs(midOld - middleNew50) > 10*mm 
		) {
			currentVerticalPositionUp = newVerticalPosition;
			return newVerticalPosition;
		}
	}
}

void init(Box b){
    background(255);
    stroke(#000000);
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
		b = new Box(calculateNewRandomHorizontalPosition(), calculateNewRandomVerticalPosition(), initialBoxSize);
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
				float middleOldWidth = b.x1 + (b.x2 / 2);
				float middleOldHeight = b.y1 + (b.y2 / 2);
				b = new Box(calculateNewRandomHorizontalPosition(), calculateNewRandomVerticalPosition(), newBoxSize);
				float middleNewWidth = b.x1 + (b.x2 / 2);
				float middleNewHeight = b.y1 + (b.y2 / 2);
				float distanceWidth = abs(middleNewWidth - middleOldWidth);
				float distanceHeight = abs(middleNewHeight - middleOldHeight);
				distancesWidth.add(distanceWidth/mm);
				distancesHeight.add(distanceHeight/mm);
				init(b);
			}
		}
	}
}