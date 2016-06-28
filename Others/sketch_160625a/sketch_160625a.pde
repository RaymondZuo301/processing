Verlet v;
float taille;

void setup() {
  size(800,800);
  smooth();
  taille = 5;
  float bordw = 0;
  float bordh = 0;
  v = new Verlet(bordw,bordh,width-bordw,height-bordh,taille*sqrt(2));
  reset();
}

void keyPressed() {
  if(key==' ') reset();
  if(key=='g') {
    v.GRAVITE = 0.1; v.ATTRACTION = 0.0;
  }
  if(key=='a') {
    v.ATTRACTION = 0.1; v.GRAVITE = 0.0;
  }
}

void reset() {
  v.clear();
  for(int i=0;i<2000;i++) {
    v.addCercle(taille*0.5);
  }
}

void draw() {
  background(0);
  //
  v.update();
  //
  stroke(255);
  strokeWeight(1);
  textSize(10);
  textAlign(CENTER,CENTER);
  for(int i=0;i<v.nForme;i++) {
    if(v.formeType[i] == v.CER) {
      noStroke();
      fill(255,150);
      ellipseMode(CENTER);
      ellipse(v.x[v.forme[i][0]],v.y[v.forme[i][0]],v.formeR[i]*2,v.formeR[i]*2);
    } else if(v.formeType[i] == v.POL) {
      fill(255,150);
      noStroke();
      beginShape();
      for(int j=0;j<v.forme[i].length;j++) {
        vertex(v.x[v.forme[i][j]],v.y[v.forme[i][j]]);
      }
      endShape(CLOSE);
    }
  }
  //
  fill(255);
  textSize(10);
  textAlign(LEFT,TOP);
  text(round(frameRate),10,10);
  //
}
public class Verlet {
  
  private float PRECISION = 0.000000001;
  
  private int CER = 0;
  private int POL = 1;
  private float FREIN = 0.99;
  private float GRAVITE = 0.0;
  private float ATTRACTION = 0.1;
  private float REPULSION = -1.0;
  private float MOUSEDSQ = 1000;
  
  private int nSom;
  private float[] x;
  private float[] y;
  private float[] px;
  private float[] py;
  private float[] ax;
  private float[] ay;
  
  private int nSeg;
  private int[] segA;
  private int[] segB;
  private float[] d;
  private float[] dSq;
  
  private int nForme;
  private int[] formeType;
  private int[][] forme;
  private float[] formeR;
  private float[] aire;
  private float[] invM;
  
  private float xmin,xmax,ymin,ymax;
  private float res,resX,resY,w,h;
  private int nColonnes,nLignes;
  private int[][][] contenu;
  
  private int repete;
  
  private boolean debug;
  private boolean resolution;
  
  public Verlet(float _xmin,float _ymin,float _xmax,float _ymax,float _res) {
    this.clear();
    this.repete = 5;
    this.debug = false;
    this.resolution = true;
    this.xmin = _xmin;
    this.xmax = _xmax;
    this.ymin = _ymin;
    this.ymax = _ymax;
    this.res = _res;
    this.w = this.xmax - this.xmin;
    this.h = this.ymax - this.ymin;
    this.nColonnes = floor(this.w/this.res);
    this.nLignes = floor(this.h/this.res);
    this.resX = this.w/this.nColonnes;
    this.resY = this.h/this.nLignes;
  }
  
  public void clear() {
    this.nSom = 0;
    this.x = new float[0];
    this.y = new float[0];
    this.px = new float[0];
    this.py = new float[0];
    this.ax = new float[0];
    this.ay = new float[0];
    this.nSeg = 0;
    this.segA = new int[0];
    this.segB = new int[0];
    this.d = new float[0];
    this.dSq = new float[0];
    this.nForme = 0;
    this.formeType = new int[0];
    this.forme = new int[0][0];
    this.formeR = new float[0];
    this.aire = new float[0];
    this.invM = new float[0];
  }
  
  void addSommet(float _x,float _y) {
    this.nSom ++;
    this.x = (float[])append(this.x,_x);
    this.y = (float[])append(this.y,_y);
    this.px = (float[])append(this.px,_x);
    this.py = (float[])append(this.py,_y);
    this.ax = (float[])append(this.ax,0.0);
    this.ay = (float[])append(this.ay,0.0);
  }
  
  void addSegment(int _a,int _b,float _d) {
    this.nSeg ++;
    this.segA = (int[])append(this.segA,_a);
    this.segB = (int[])append(this.segB,_b);
    this.d = (float[])append(this.d,_d);
    this.dSq = (float[])append(this.dSq,_d*_d);
  }
  
  void addCercle(float _r) {
    this.addCercle(random(this.xmin+_r,this.xmax-_r),random(this.ymin+_r,this.ymax-_r),_r);
  }
  
  void addCercle(float _x, float _y,float _r) {
    this.nForme ++;
    this.formeType = (int[])append(this.formeType,this.CER);
    this.forme = (int[][])append(this.forme,new int[1]);
    this.forme[this.nForme-1][0] = this.nSom;
    this.formeR = (float[])append(this.formeR,_r);
    this.aire = (float[])append(this.aire,PI*_r*_r);
    this.invM = (float[])append(this.invM,1/this.aire[this.aire.length-1]);
    this.addSommet(_x,_y);
  }
  
  void addTriangleEquilateral(float _d) {
    float cx = random(this.xmin,this.xmax);
    float cy = random(this.ymin,this.ymax);
    this.addTriangleEquilateral(cx,cy,_d);
  }
  
  void addTriangleEquilateral(float _x,float _y,float _d) {
    this.nForme ++;
    this.formeType = (int[])append(this.formeType,this.POL);
    this.forme = (int[][])append(this.forme,new int[3]);
    this.forme[this.nForme-1][0] = this.nSom;
    this.forme[this.nForme-1][1] = this.nSom+1;
    this.forme[this.nForme-1][2] = this.nSom+2;
    this.formeR = (float[])append(this.formeR,0.0);
    // formule de heron pour l'aire d'un triangle selon la longueur de ses cotés
    // pourrait être optimisée
    float s = 0.5*(_d+_d+_d);
    float a = sqrt(s*(s-_d)*(s-_d)*(s-_d));
    this.aire = (float[])append(this.aire,a);
    this.invM = (float[])append(this.invM,1/this.aire[this.aire.length-1]);
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSegment(this.nSom-3,this.nSom-2,_d);
    this.addSegment(this.nSom-2,this.nSom-1,_d);
    this.addSegment(this.nSom-1,this.nSom-3,_d);
  }
  
  void addTriangleRectangle(float _d) {
    float cx = random(this.xmin,this.xmax);
    float cy = random(this.ymin,this.ymax);
    this.addTriangleRectangle(cx,cy,_d);
  }
  
  void addTriangleRectangle(float _x,float _y,float _d) {
    this.nForme ++;
    this.formeType = (int[])append(this.formeType,this.POL);
    this.forme = (int[][])append(this.forme,new int[3]);
    this.forme[this.nForme-1][0] = this.nSom;
    this.forme[this.nForme-1][1] = this.nSom+1;
    this.forme[this.nForme-1][2] = this.nSom+2;
    this.formeR = (float[])append(this.formeR,0.0);
    // formule de heron pour l'aire d'un triangle selon la longueur de ses cotés
    // pourrait être optimisée
    float s = 0.5*(_d+_d+_d);
    float a = sqrt(s*(s-_d)*(s-_d)*(s-_d));
    this.aire = (float[])append(this.aire,a);
    this.invM = (float[])append(this.invM,1/this.aire[this.aire.length-1]);
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSegment(this.nSom-3,this.nSom-2,_d);
    this.addSegment(this.nSom-2,this.nSom-1,_d);
    this.addSegment(this.nSom-1,this.nSom-3,_d*sqrt(2));
  }
  
  void addCarre(float _d) {
    float cx = random(this.xmin,this.xmax);
    float cy = random(this.ymin,this.ymax);
    this.addCarre(cx,cy,_d);
  }
  
  void addCarre(float _x,float _y,float _d) {
    this.nForme ++;
    this.formeType = (int[])append(this.formeType,this.POL);
    this.forme = (int[][])append(this.forme,new int[4]);
    this.forme[this.nForme-1][0] = this.nSom;
    this.forme[this.nForme-1][1] = this.nSom+1;
    this.forme[this.nForme-1][2] = this.nSom+2;
    this.forme[this.nForme-1][3] = this.nSom+3;
    this.formeR = (float[])append(this.formeR,0.0);
    this.aire = (float[])append(this.aire,_d*_d);
    this.invM = (float[])append(this.invM,1/this.aire[this.aire.length-1]);
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSommet(_x+random(-_d,_d),_y+random(-_d,_d));
    this.addSegment(this.nSom-4,this.nSom-3,_d);
    this.addSegment(this.nSom-3,this.nSom-2,_d);
    this.addSegment(this.nSom-2,this.nSom-1,_d);
    this.addSegment(this.nSom-1,this.nSom-4,_d);
    this.addSegment(this.nSom-1,this.nSom-3,_d*sqrt(2));
    this.addSegment(this.nSom-2,this.nSom-4,_d*sqrt(2));
  }
  
  void addRectangle(float _w,float _h) {
    float cx = random(this.xmin,this.xmax);
    float cy = random(this.ymin,this.ymax);
    this.addRectangle(cx,cy,_w,_h);
  }
  
  void addRectangle(float _x,float _y,float _w,float _h) {
    this.nForme ++;
    this.formeType = (int[])append(this.formeType,this.POL);
    this.forme = (int[][])append(this.forme,new int[4]);
    this.forme[this.nForme-1][0] = this.nSom;
    this.forme[this.nForme-1][1] = this.nSom+1;
    this.forme[this.nForme-1][2] = this.nSom+2;
    this.forme[this.nForme-1][3] = this.nSom+3;
    this.formeR = (float[])append(this.formeR,0.0);
    this.aire = (float[])append(this.aire,_w*_h);
    this.invM = (float[])append(this.invM,1/this.aire[this.aire.length-1]);
    this.addSommet(_x+random(-_w,_w),_y+random(-_h,_h));
    this.addSommet(_x+random(-_w,_w),_y+random(-_h,_h));
    this.addSommet(_x+random(-_w,_w),_y+random(-_h,_h));
    this.addSommet(_x+random(-_w,_w),_y+random(-_h,_h));
    this.addSegment(this.nSom-4,this.nSom-3,_w);
    this.addSegment(this.nSom-3,this.nSom-2,_h);
    this.addSegment(this.nSom-2,this.nSom-1,_w);
    this.addSegment(this.nSom-1,this.nSom-4,_h);
    this.addSegment(this.nSom-1,this.nSom-3,sqrt(_w*_w+_h*_h));
    this.addSegment(this.nSom-2,this.nSom-4,sqrt(_w*_w+_h*_h));
  }
  
  void addPolygone() {
    
  }
  
  void update() {
    this.decroiser();
    this.acceleration(1.0);
    this.contrainte();
    this.inertie();
    this.contrainte();
  }
  
  private void decroiser() { // valable pour l'instant pour les carres et rectangles (polygone avec 4 sommets)
    for(int i=0;i<this.nForme;i++) {
      if(this.formeType[i] == this.CER) continue;
      if(this.forme[i].length == 3) continue;
      for(int j=0;j<this.forme[i].length;j++) {
        if(segIntersection(this.x[this.forme[i][j]],this.y[this.forme[i][j]],
                           this.x[this.forme[i][(j+1)%this.forme[i].length]],this.y[this.forme[i][(j+1)%this.forme[i].length]],
                           this.x[this.forme[i][(j+2)%this.forme[i].length]],this.y[this.forme[i][(j+2)%this.forme[i].length]],
                           this.x[this.forme[i][(j+3)%this.forme[i].length]],this.y[this.forme[i][(j+3)%this.forme[i].length]])) {
          
          float xTemp = this.x[this.forme[i][(j+1)%this.forme[i].length]];
          float yTemp = this.y[this.forme[i][(j+1)%this.forme[i].length]];
          this.px[this.forme[i][(j+1)%this.forme[i].length]] = this.x[this.forme[i][(j+2)%this.forme[i].length]];
          this.py[this.forme[i][(j+1)%this.forme[i].length]] = this.y[this.forme[i][(j+2)%this.forme[i].length]];
          this.x[this.forme[i][(j+1)%this.forme[i].length]] = this.x[this.forme[i][(j+2)%this.forme[i].length]];
          this.y[this.forme[i][(j+1)%this.forme[i].length]] = this.y[this.forme[i][(j+2)%this.forme[i].length]];
          this.px[this.forme[i][(j+2)%this.forme[i].length]] = xTemp;
          this.py[this.forme[i][(j+2)%this.forme[i].length]] = yTemp;
          this.x[this.forme[i][(j+2)%this.forme[i].length]] = xTemp;
          this.y[this.forme[i][(j+2)%this.forme[i].length]] = yTemp;
        }
      }
    }
  }
  
  private void acceleration(float timeStep) { // forces, gravité etc.
    for(int i=0;i<this.nForme;i++) {
      // force gravité
      for(int j=0;j<this.forme[i].length;j++) {
        this.ay[this.forme[i][j]] += this.GRAVITE;//* this.invM[i];
      }
      // force attraction centre
      for(int j=0;j<this.forme[i].length;j++) {
        float dx = (this.xmin+this.xmax)*0.5 - this.x[this.forme[i][j]];
        float dy = (this.ymin+this.ymax)*0.5 - this.y[this.forme[i][j]];
        float d = sqrt(dx*dx+dy*dy);
        dx /= d;
        dy /= d;
        this.ax[this.forme[i][j]] += dx * this.ATTRACTION;
        this.ay[this.forme[i][j]] += dy * this.ATTRACTION;
      }
      // force repulsion souris
      for(int j=0;j<this.forme[i].length;j++) {
        float dx = mouseX - this.x[this.forme[i][j]];
        float dy = mouseY - this.y[this.forme[i][j]];
        float dSq = (dx*dx+dy*dy);
        if(dSq<this.MOUSEDSQ) {
          float d = sqrt(dSq);
          dx /= d;
          dy /= d;
          this.ax[this.forme[i][j]] += dx * this.REPULSION;
          this.ay[this.forme[i][j]] += dy * this.REPULSION;
        }
      }
      // accelerer
      for(int j=0;j<this.forme[i].length;j++) {
        this.x[this.forme[i][j]] += this.ax[this.forme[i][j]] * timeStep * timeStep;
        this.y[this.forme[i][j]] += this.ay[this.forme[i][j]] * timeStep * timeStep;
      }
      // reset acceleration = 0
      for(int j=0;j<this.forme[i].length;j++) {
        this.ax[this.forme[i][j]] = 0.0;
        this.ay[this.forme[i][j]] = 0.0;
      }
    }
  }
  
  private void inertie() { //
    for(int i=0;i<this.nSom;i++) {
      float newx = this.x[i] + ( this.x[i] - this.px[i] ) * this.FREIN;
      float newy = this.y[i] + ( this.y[i] - this.py[i] ) * this.FREIN;
      this.px[i] = this.x[i];
      this.py[i] = this.y[i];
      this.x[i] = newx;
      this.y[i] = newy;
    }
  }
  
  private void contrainte() { // segment, collision, cadre
    for(int r=0;r<this.repete;r++) {
      // segments
      float dx,dy,distSq,dist,rapport;
      for(int i=0;i<this.nSeg;i++) {
        dx = this.x[this.segB[i]] - this.x[this.segA[i]];
        dy = this.y[this.segB[i]] - this.y[this.segA[i]];
        distSq = dx*dx+dy*dy;
        if(abs(distSq-this.dSq[i])<this.PRECISION) continue;
        dist = sqrt(distSq);
        if(dist<this.PRECISION) {
          dist = this.PRECISION;
        }
        rapport = this.d[i]/dist - 1;
        dx = dx*rapport*0.5;
        dy = dy*rapport*0.5;
        this.x[this.segA[i]] -= dx;
        this.y[this.segA[i]] -= dy;
        this.x[this.segB[i]] += dx;
        this.y[this.segB[i]] += dy;
      }
      // grille
      this.contenu   = new int[this.nColonnes][this.nLignes][0];
      for(int i=0;i<this.forme.length;i++) {
        if(this.formeType[i] == this.CER) {
          int nC = floor(this.x[this.forme[i][0]]/this.resX);
          int nL = floor(this.y[this.forme[i][0]]/this.resY);
          nC = constrain(nC,0,this.nColonnes-1);
          nL = constrain(nL,0,this.nLignes-1);
          this.contenu[nC][nL] = (int[])append(this.contenu[nC][nL],i);
        }
        if(this.formeType[i] == this.POL) {
          float cx = 0.0;
          float cy = 0.0;
          for(int j=0;j<this.forme[i].length;j++) {
            cx += this.x[this.forme[i][j]];
            cy += this.y[this.forme[i][j]];
          }
          cx /= this.forme[i].length;
          cy /= this.forme[i].length;
          int nC = floor(cx/this.resX);
          int nL = floor(cy/this.resY);
          nC = constrain(nC,0,this.nColonnes-1);
          nL = constrain(nL,0,this.nLignes-1);
          this.contenu[nC][nL] = (int[])append(this.contenu[nC][nL],i);
        }
      }
      // collision
      for(int hx=0;hx<this.nColonnes;hx++) {
        for(int hy=0;hy<this.nLignes;hy++) {
          for(int i=0;i<this.contenu[hx][hy].length;i++) {
            if(i<this.contenu[hx][hy].length-1) {
              for(int j=i+1;j<this.contenu[hx][hy].length;j++) {
                this.collision(this.contenu[hx][hy][i],this.contenu[hx][hy][j]);
              }
            }
            for(int k=0;k<2;k++) {
              if(hx+k<0||hx+k>=this.nColonnes) continue;
              for(int l=-1;l<2;l++) {
                if(hy+l<0||hy+l>=this.nLignes||k==0&&l==-1||k==0&&l==0) continue;
                for(int m=0;m<this.contenu[hx+k][hy+l].length;m++) {
                  this.collision(this.contenu[hx][hy][i],this.contenu[hx+k][hy+l][m]);
                }
              }
            }
          }
        }
      }
      // cadre
      for(int i=0;i<this.nForme;i++) {
        if(this.formeType[i] == this.CER) {
          if(this.x[this.forme[i][0]] < this.xmin+this.formeR[i]) {
            this.x[this.forme[i][0]] = this.xmin+this.formeR[i];
          } else if(this.x[this.forme[i][0]] > this.xmax-this.formeR[i]) {
            this.x[this.forme[i][0]] = this.xmax-this.formeR[i];
          }
          if(this.y[this.forme[i][0]] < this.ymin+this.formeR[i]) {
            this.y[this.forme[i][0]] = this.ymin+this.formeR[i];
          } else if(this.y[this.forme[i][0]] > this.ymax-this.formeR[i]) {
            this.y[this.forme[i][0]] = this.ymax-this.formeR[i];
          }
        } else if(this.formeType[i] == this.POL) {
          for(int j=0;j<this.forme[i].length;j++) {
            if(this.x[this.forme[i][j]] < this.xmin) {
              this.x[this.forme[i][j]] = this.xmin;
            } else if(this.x[this.forme[i][j]] > this.xmax) {
              this.x[this.forme[i][j]] = this.xmax;
            }
            if(this.y[this.forme[i][j]] < this.ymin) {
              this.y[this.forme[i][j]] = this.ymin;
            } else if(this.y[this.forme[i][j]] > this.ymax) {
              this.y[this.forme[i][j]] = this.ymax;
            }
          }
        }
      }
    }
  }
  
  private void collision(int _a,int _b) {
    if( this.formeType[_a] == this.CER && this.formeType[_b] == this.CER ) {
      this.collisionCercleCercle(_a,_b);
    }
    if( this.formeType[_a] == this.CER && this.formeType[_b] == this.POL) {
      this.collisionCerclePolygone(_a,_b);
    }
    if( this.formeType[_a] == this.POL && this.formeType[_b] == this.CER) {
      this.collisionCerclePolygone(_b,_a);
    }
    if( this.formeType[_a] == this.POL && this.formeType[_b] == this.POL ) {
      this.collisionPolygonePolygone(_a,_b);
    }
  }
  
  private void collisionCercleCercle(int _a,int _b) {
    float dx,dy,distSq,dist,rr,rrSq,rapport;
    int a = this.forme[_a][0];
    int b = this.forme[_b][0];
    dx = this.x[b] - this.x[a];
    dy = this.y[b] - this.y[a];
    distSq = dx*dx+dy*dy;
    rr = this.formeR[_a] + this.formeR[_b];
    rrSq = rr*rr;
    if(distSq>rrSq-this.PRECISION) return;
    dist = sqrt(distSq);
    if(dist<this.PRECISION) {
      dist = this.PRECISION;
    }
    rapport = rr/dist - 1;
    dx = dx*rapport*0.5;
    dy = dy*rapport*0.5;
    // option affichage des infos
    if(this.debug) {
      stroke(255,0,0);
      strokeWeight(2);
      noFill();
      line(this.x[this.forme[_a][0]],
           this.y[this.forme[_a][0]],
           this.x[this.forme[_a][0]]-dx,
           this.y[this.forme[_a][0]]-dy
          );
      line(this.x[this.forme[_b][0]],
           this.y[this.forme[_b][0]],
           this.x[this.forme[_b][0]]+dx,
           this.y[this.forme[_b][0]]+dy
          );
    }
    // deplacement
    if(resolution) {
      this.x[a] -= dx;
      this.y[a] -= dy;
      this.x[b] += dx;
      this.y[b] += dy;
    }
  }
  
  private void collisionCerclePolygone(int c,int p) {
    // test AABB
    float cxmin = this.x[this.forme[c][0]]-this.formeR[c];
    float cxmax = this.x[this.forme[c][0]]+this.formeR[c];
    float cymin = this.y[this.forme[c][0]]-this.formeR[c];
    float cymax = this.y[this.forme[c][0]]+this.formeR[c];
    float pxmin = this.x[this.forme[p][0]];
    float pxmax = this.x[this.forme[p][0]];
    float pymin = this.y[this.forme[p][0]];
    float pymax = this.y[this.forme[p][0]];
    for(int i=1;i<this.forme[p].length;i++) {
      if(this.x[this.forme[p][i]]<pxmin) pxmin = this.x[this.forme[p][i]];
      if(this.x[this.forme[p][i]]>pxmax) pxmax = this.x[this.forme[p][i]];
      if(this.y[this.forme[p][i]]<pymin) pymin = this.y[this.forme[p][i]];
      if(this.y[this.forme[p][i]]>pymax) pymax = this.y[this.forme[p][i]];
    }
    if(cxmin>pxmax||cxmax<pxmin||cymin>pymax||cymax<pymin) {
      return;
    }
    // SAT + regions
    //
    float airec = this.aire[c];
    float airep = this.getAire(this.forme[p]);
    float dist;
    float nx,ny; // composantes des normales
    float nx0,nx1,ny0,ny1; // extremites des normales
    float proj;
    int collNId = -1; // id de la normale
    float collNX = 0.0; // composantes de la normale de la collision
    float collNY = 0.0; // composantes de la normale de la collision
    float colldx = 0.0;
    float colldy = 0.0;
//    float profondeurMin = Float.MAX_VALUE;
    float profondeurMin = 100000000;
    float rapport = 1.0;
    int region = -1;
    float dx,dy,distSq,r,rSq;
    //
    //
    // projection sur p
    for(int i=0;i<this.forme[p].length;i++) {
      // region
      proj = projSommetDroiteCoef(this.x[this.forme[p][i]],this.y[this.forme[p][i]],
                                  this.x[this.forme[p][(i+1)%this.forme[p].length]],this.y[this.forme[p][(i+1)%this.forme[p].length]],
                                  this.x[this.forme[c][0]],this.y[this.forme[c][0]]);
      if(i==0 && proj<this.PRECISION) {
        proj = projSommetDroiteCoef(this.x[this.forme[p][i]],this.y[this.forme[p][i]],
                                    this.x[this.forme[p][(i-1+this.forme[p].length)%this.forme[p].length]],this.y[this.forme[p][(i-1+this.forme[p].length)%this.forme[p].length]],
                                    this.x[this.forme[c][0]],this.y[this.forme[c][0]]);
        if(proj<this.PRECISION) {
          region = 0;
        }
      } else if(proj>1-this.PRECISION) {
        proj = projSommetDroiteCoef(this.x[this.forme[p][(i+1)%this.forme[p].length]],this.y[this.forme[p][(i+1)%this.forme[p].length]],
                                    this.x[this.forme[p][(i+2)%this.forme[p].length]],this.y[this.forme[p][(i+2)%this.forme[p].length]],
                                    this.x[this.forme[c][0]],this.y[this.forme[c][0]]);
        if(proj<this.PRECISION) {
          region = (i+1)%this.forme[p].length;
        }
      }
      // resolution region
      if(region != -1) {
        dx = this.x[this.forme[p][region]] - this.x[this.forme[c][0]];
        dy = this.y[this.forme[p][region]] - this.y[this.forme[c][0]];
        distSq = dx*dx+dy*dy;
        r = this.formeR[c];
        rSq = r*r;
        if(distSq>rSq-this.PRECISION) return;
        dist = sqrt(distSq);
        if(dist<this.PRECISION) {
          dist = this.PRECISION;
        }
        rapport = r/dist - 1;
        dx = dx*rapport*0.5;
        dy = dy*rapport*0.5;
        // option affichage des infos
        if(this.debug) {
          stroke(255,0,0);
          strokeWeight(2);
          noFill();
          line(this.x[this.forme[c][0]],
               this.y[this.forme[c][0]],
               this.x[this.forme[c][0]]-dx,
               this.y[this.forme[c][0]]-dy
              );
          line(this.x[this.forme[p][region]],
               this.y[this.forme[p][region]],
               this.x[this.forme[p][region]]+dx,
               this.y[this.forme[p][region]]+dy
              );
        }
        // deplacement
        if(this.resolution) {
          this.x[this.forme[c][0]] -= dx;
          this.y[this.forme[c][0]] -= dy;
          this.x[this.forme[p][region]] += dx;
          this.y[this.forme[p][region]] += dy;
        }
        //
        return;
      }
      // sinon SAT
      // déterminer les normales
      nx0 = this.x[this.forme[p][i]];
      ny0 = this.y[this.forme[p][i]];
      if(airep>0) { // normale gauche
        nx = this.y[this.forme[p][(i+1)%this.forme[p].length]] - this.y[this.forme[p][i]];
        ny = - ( this.x[this.forme[p][(i+1)%this.forme[p].length]] - this.x[this.forme[p][i]] );
      } else { // normale droite
        nx = - ( this.y[this.forme[p][(i+1)%this.forme[p].length]] - this.y[this.forme[p][i]] );
        ny = this.x[this.forme[p][(i+1)%this.forme[p].length]] - this.x[this.forme[p][i]];
      }
      dist = sqrt(nx*nx+ny*ny);
      nx /= dist;
      ny /= dist;
      nx1 = nx0+nx;
      ny1 = ny0+ny;
      // projection de la forme c
      proj = projSommetDroiteCoef(nx0,ny0,
                                  nx1,ny1,
                                  this.x[this.forme[c][0]],this.y[this.forme[c][0]]);
      if(proj>this.formeR[c]-this.PRECISION) {
        return;
      } else {
        if(abs(proj-this.formeR[c])<profondeurMin) {
          collNId = i;
          collNX = nx;
          collNY = ny;
          profondeurMin = abs(proj-this.formeR[c]);
        }
      }
    }
    // resolution SAT
    if(collNId>-1) {
      colldx = collNX*profondeurMin*0.5;
      colldy = collNY*profondeurMin*0.5;
      // ponderation le long du coté support de normale
      proj = projSommetDroiteCoef(this.x[this.forme[p][collNId]],this.y[this.forme[p][collNId]],
                                  this.x[this.forme[p][(collNId+1)%this.forme[p].length]],this.y[this.forme[p][(collNId+1)%this.forme[p].length]],
                                  this.x[this.forme[c][0]],this.y[this.forme[c][0]]);
      float coefa=1.0;
      float coefb=1.0;
      if(proj<this.PRECISION) {
        coefa = 1.0;
        coefb = 0.0;
      } else if(proj>1-this.PRECISION) {
        coefa = 0.0;
        coefb = 1.0;
      } else {
        coefa = 1-proj;
        coefb = proj;
      }
      // ponderation selon les aires
      float rapport1 = 1.0;
      float rapport2 = 1.0;
      /*
      if(abs(airep)<abs(airec)) {
        rapport = abs(airep)/abs(airec);
        rapport1 = 2-rapport;
        rapport2 = rapport;
      } else {
        rapport = abs(airec)/abs(airep);
        rapport1 = rapport;
        rapport2 = 2-rapport;
      }
      */
      // option affichage des infos
      if(this.debug) {
        stroke(255,0,0);
        strokeWeight(2);
        noFill();
        line((this.x[this.forme[p][collNId]]+this.x[this.forme[p][(collNId+1)%this.forme[p].length]])*0.5,
             (this.y[this.forme[p][collNId]]+this.y[this.forme[p][(collNId+1)%this.forme[p].length]])*0.5,
             (this.x[this.forme[p][collNId]]+this.x[this.forme[p][(collNId+1)%this.forme[p].length]])*0.5+colldx*2,
             (this.y[this.forme[p][collNId]]+this.y[this.forme[p][(collNId+1)%this.forme[p].length]])*0.5+colldy*2
            );
      }
      // deplacement
      if(this.resolution) {
        this.x[this.forme[p][collNId]] -= colldx * rapport1 * coefa;
        this.y[this.forme[p][collNId]] -= colldy * rapport1 * coefa;
        this.x[this.forme[p][(collNId+1)%this.forme[p].length]] -= colldx * rapport1 * coefb;
        this.y[this.forme[p][(collNId+1)%this.forme[p].length]] -= colldy * rapport1 * coefb;
        this.x[this.forme[c][0]] += colldx * rapport2;
        this.y[this.forme[c][0]] += colldy * rapport2;
      }
    }
  }
  
  private void collisionPolygonePolygone(int a,int b) {
    // test AABB
    float axmin = this.x[this.forme[a][0]];
    float axmax = this.x[this.forme[a][0]];
    float aymin = this.y[this.forme[a][0]];
    float aymax = this.y[this.forme[a][0]];
    float bxmin = this.x[this.forme[b][0]];
    float bxmax = this.x[this.forme[b][0]];
    float bymin = this.y[this.forme[b][0]];
    float bymax = this.y[this.forme[b][0]];
    for(int i=1;i<this.forme[a].length;i++) {
      if(this.x[this.forme[a][i]]<axmin) axmin = this.x[this.forme[a][i]];
      if(this.x[this.forme[a][i]]>axmax) axmax = this.x[this.forme[a][i]];
      if(this.y[this.forme[a][i]]<aymin) aymin = this.y[this.forme[a][i]];
      if(this.y[this.forme[a][i]]>aymax) aymax = this.y[this.forme[a][i]];
    }
    for(int i=1;i<this.forme[b].length;i++) {
      if(this.x[this.forme[b][i]]<bxmin) bxmin = this.x[this.forme[b][i]];
      if(this.x[this.forme[b][i]]>bxmax) bxmax = this.x[this.forme[b][i]];
      if(this.y[this.forme[b][i]]<bymin) bymin = this.y[this.forme[b][i]];
      if(this.y[this.forme[b][i]]>bymax) bymax = this.y[this.forme[b][i]];
    }
    if(axmin>bxmax||axmax<bxmin||aymin>bymax||aymax<bymin) {
      return;
    }
    // SAT
    //
    float airea,aireb;
    float dist;
    float nx,ny; // composantes des normales
    float nx0,nx1,ny0,ny1; // extremites des normales
    float p1min,p1max,p2min,p2max,proj;
    int collPId1 = -1; // polygone support de normale
    int collPId2 = -1; // autre polygone
    int collNId = -1; // id de la normale
    float collNX = 0.0; // composantes de la normale de la collision
    float collNY = 0.0; // composantes de la normale de la collision
    int sMinId = -1; // id du sommet le plus profond de l'autre polygone dans tous les cas
    int collSId = -1; // id du sommet le plus profond de l'autre polygone en cas de collision
    float colldx = 0.0;
    float colldy = 0.0;
//    float profondeurMin = Float.MAX_VALUE;
    float profondeurMin = 100000000;
    //
    // projection sur les normales de a
    airea = this.getAire(this.forme[a]);
    for(int i=0;i<this.forme[a].length;i++) {
      // déterminer les normales
      nx0 = this.x[this.forme[a][i]];
      ny0 = this.y[this.forme[a][i]];
      if(airea>0) { // normale gauche
        nx = this.y[this.forme[a][(i+1)%this.forme[a].length]] - this.y[this.forme[a][i]];
        ny = - ( this.x[this.forme[a][(i+1)%this.forme[a].length]] - this.x[this.forme[a][i]] );
      } else { // normale droite
        nx = - ( this.y[this.forme[a][(i+1)%this.forme[a].length]] - this.y[this.forme[a][i]] );
        ny = this.x[this.forme[a][(i+1)%this.forme[a].length]] - this.x[this.forme[a][i]];
      }
      dist = sqrt(nx*nx+ny*ny);
      nx /= dist;
      ny /= dist;
      nx1 = nx0+nx;
      ny1 = ny0+ny;
      // projection de la forme a
      p1min = 0;
      p1max = 0;
      for(int j=1;j<this.forme[a].length;j++) {
        proj = projSommetDroiteCoef(nx0,ny0,
                                    nx1,ny1,
                                    this.x[this.forme[a][(i+j)%this.forme[a].length]],this.y[this.forme[a][(i+j)%this.forme[a].length]]);
        if(proj<p1min) p1min = proj;
        if(proj>p1max) p1max = proj;
      }
      // projection de la forme b
      proj = projSommetDroiteCoef(nx0,ny0,
                                  nx1,ny1,
                                  this.x[this.forme[b][0]],this.y[this.forme[b][0]]);
      p2min = proj;
      p2max = proj;
      sMinId = 0;
      for(int j=1;j<this.forme[b].length;j++) {
        proj = projSommetDroiteCoef(nx0,ny0,
                                    nx1,ny1,
                                    this.x[this.forme[b][j]],this.y[this.forme[b][j]]);
        if(proj<p2min) {
          p2min = proj;
          sMinId = j;
        }
        if(proj>p2max) p2max = proj;
      }
      // test de collision
      if(p2min>-this.PRECISION||p2max<p1min+this.PRECISION) {
        return;
      } else {
        if(abs(p2min)<profondeurMin) {
          profondeurMin = abs(p2min);
          collPId1 = a;
          collPId2 = b;
          collNId = i;
          collNX = nx;
          collNY = ny;
          collSId = sMinId;
        }
      }
    }
    // projection sur les normales de b
    aireb = this.getAire(this.forme[b]);
    for(int i=0;i<this.forme[b].length;i++) {
      // déterminer les normales
      nx0 = this.x[this.forme[b][i]];
      ny0 = this.y[this.forme[b][i]];
      if(aireb>0) { // normale gauche
        nx = this.y[this.forme[b][(i+1)%this.forme[b].length]] - this.y[this.forme[b][i]];
        ny = - ( this.x[this.forme[b][(i+1)%this.forme[b].length]] - this.x[this.forme[b][i]] );
      } else { // normale droite
        nx = - ( this.y[this.forme[b][(i+1)%this.forme[b].length]] - this.y[this.forme[b][i]] );
        ny = this.x[this.forme[b][(i+1)%this.forme[b].length]] - this.x[this.forme[b][i]];
      }
      dist = sqrt(nx*nx+ny*ny);
      nx /= dist;
      ny /= dist;
      nx1 = nx0+nx;
      ny1 = ny0+ny;
      //
      // projection de la forme b
      p2min = 0;
      p2max = 0;
      for(int j=1;j<this.forme[b].length;j++) {
        proj = projSommetDroiteCoef(nx0,ny0,
                                    nx1,ny1,
                                    this.x[this.forme[b][(i+j)%this.forme[b].length]],this.y[this.forme[b][(i+j)%this.forme[b].length]]);
        if(proj<p2min) p2min = proj;
        if(proj>p2max) p2max = proj;
      }
      // projection de la forme a
      proj = projSommetDroiteCoef(nx0,ny0,
                                  nx1,ny1,
                                  this.x[this.forme[a][0]],this.y[this.forme[a][0]]);
      sMinId = 0;
      p1min = proj;
      p1max = proj;
      for(int j=1;j<this.forme[a].length;j++) {
        proj = projSommetDroiteCoef(nx0,ny0,
                                    nx1,ny1,
                                    this.x[this.forme[a][j]],this.y[this.forme[a][j]]);
        if(proj<p1min) {
          p1min = proj;
          sMinId = j;
        }
        if(proj>p1max) p1max = proj;
      }
      // test de collision
      if(p1min>-this.PRECISION||p1max<p2min+this.PRECISION) {
        return;
      } else {
        if(abs(p1min)<profondeurMin) {
          profondeurMin = abs(p1min);
          collPId1 = b;
          collPId2 = a;
          collNId = i;
          collNX = nx;
          collNY = ny;
          collSId = sMinId;
        }
      }
    }
    //
    // resolution de la collision
    //
    // s'il y a eu un problème.... il faut encore vérifier... normalement il devrait y avoir collision...
     if(collPId1 == -1 || collPId2 == -1 || collNId == -1 || collSId == -1) {
       //println("collision > problème SAT poly/poly");
       return;
     }
    // profondeur
    colldx = collNX*profondeurMin*0.5;
    colldy = collNY*profondeurMin*0.5;
    // ponderation le long du coté support de normale
    proj = projSommetDroiteCoef(this.x[this.forme[collPId1][collNId]],this.y[this.forme[collPId1][collNId]],
                                this.x[this.forme[collPId1][(collNId+1)%this.forme[collPId1].length]],this.y[this.forme[collPId1][(collNId+1)%this.forme[collPId1].length]],
                                this.x[this.forme[collPId2][collSId]],this.y[this.forme[collPId2][collSId]]);
    float coefa=1.0;
    float coefb=1.0;
    if(proj<this.PRECISION) {
      coefa = 1.0;
      coefb = 0.0;
    } else if(proj>1-this.PRECISION) {
      coefa = 0.0;
      coefb = 1.0;
    } else {
      coefa = 1-proj;
      coefb = proj;
    }
    // ponderation selon les aires
    float rapport = 1.0;
    float rapport1 = 1.0;
    float rapport2 = 1.0;
    /*
    if(collPId1 == a) {
      if(abs(airea)<abs(aireb)) {
        rapport = abs(airea)/abs(aireb);
        rapport1 = 2-rapport;
        rapport2 = rapport;
      } else {
        rapport = abs(aireb)/abs(airea);
        rapport1 = rapport;
        rapport2 = 2-rapport;
      }
    } else if(collPId1 == b) {
      if(abs(airea)<abs(aireb)) {
        rapport = abs(airea)/abs(aireb);
        rapport1 = rapport;
        rapport2 = 2-rapport;
      } else {
        rapport = abs(aireb)/abs(airea);
        rapport1 = 2-rapport;
        rapport2 = rapport;
      }
    }
    */
    // option affichage des infos
    if(this.debug) {
      stroke(255,0,0);
      strokeWeight(2);
      noFill();
      ellipseMode(CENTER);
      ellipse(this.x[this.forme[collPId2][collSId]],this.y[this.forme[collPId2][collSId]],5,5);
      line((this.x[this.forme[collPId1][collNId]]+this.x[this.forme[collPId1][(collNId+1)%this.forme[collPId1].length]])*0.5,
           (this.y[this.forme[collPId1][collNId]]+this.y[this.forme[collPId1][(collNId+1)%this.forme[collPId1].length]])*0.5,
           (this.x[this.forme[collPId1][collNId]]+this.x[this.forme[collPId1][(collNId+1)%this.forme[collPId1].length]])*0.5+colldx*2,
           (this.y[this.forme[collPId1][collNId]]+this.y[this.forme[collPId1][(collNId+1)%this.forme[collPId1].length]])*0.5+colldy*2
          );
    }
    // deplacement
    if(this.resolution) {
      this.x[this.forme[collPId1][collNId]] -= colldx * rapport1 * coefa;
      this.y[this.forme[collPId1][collNId]] -= colldy * rapport1 * coefa;
      this.x[this.forme[collPId1][(collNId+1)%this.forme[collPId1].length]] -= colldx * rapport1 * coefb;
      this.y[this.forme[collPId1][(collNId+1)%this.forme[collPId1].length]] -= colldy * rapport1 * coefb;
      this.x[this.forme[collPId2][collSId]] += colldx * rapport2;
      this.y[this.forme[collPId2][collSId]] += colldy * rapport2;
    }
  }
  
  private float projSommetDroiteCoef(float x1, float y1,float x2, float y2,float x3,float y3) {
    return ((x3-x1)*(x2-x1)+(y3-y1)*(y2-y1))/((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
  }
  
  private float getAire(int[] s) {
    int i,j;
    float aire = 0.0;
    for (i=0;i<s.length;i++) {
      j = (i+1)%s.length;
      aire += this.x[s[i]]*this.y[s[j]];
      aire -= this.y[s[i]]*this.x[s[j]];
    }
    return aire * 0.5;
  }
  
  private boolean segIntersection(float x1,float y1,float x2,float y2,float x3,float y3,float x4,float y4) {
    float bx = x2 - x1;
    float by = y2 - y1;
    float dx = x4 - x3;
    float dy = y4 - y3;
    float b_dot_d_perp = bx * dy - by * dx;
    if(b_dot_d_perp == 0) {
      return false;
    }
    float cx = x3 - x1;
    float cy = y3 - y1;
    float t = (cx * dy - cy * dx) / b_dot_d_perp;
    if(t < 0 || t > 1) {
      return false;
    }
    float u = (cx * by - cy * bx) / b_dot_d_perp;
    if(u < 0 || u > 1) { 
      return false;
    }
    return true;
  }
  
}