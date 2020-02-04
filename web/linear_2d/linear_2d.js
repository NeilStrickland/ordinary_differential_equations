var linear_2d = {};

linear_2d.create = function(A) {
 var L = Object.create(this);

 L.A = A;
 L.walkers = [];
 L.group = null;

 return L;
};

linear_2d.create_xhr = function() {
 var x;

 x = null;

 if (window.ActiveXObject) {
  x = new ActiveXObject("Microsoft.XMLHTTP");
 } else if(window.XMLHttpRequest) {
  x = new XMLHttpRequest();
 }

 if (x) {
  return(x);
 } else {
  alert('Could not create XMLHttpRequest object to connect to server');
  return(null);
 }
};

linear_2d.create_group = function() {
 this.group = new paper.Group();
 this.group.transformContent = false;
 this.group.translate(new paper.Point(1100,-1100));
 this.group.scale(0.2,-0.2);
};

linear_2d.draw_outline = function() {
 this.outline = new paper.Path.Circle(new paper.Point(0,0),1000);
 this.outline.strokeWidth = 2;
 this.outline.strokeColor = 'grey';
 this.group.addChild(this.outline);
};

linear_2d.draw_eigenlines = function() {
 var u,v,p;

 u = this.u_hat[0];
 v = [-u[0],-u[1]];
 p = new paper.Path(u,v);
 p.strokeColor = 'cyan';
 p.strokeWidth = 2;
 this.group.addChild(p);

 u = this.u_hat[1];
 v = [-u[0],-u[1]];
 p = new paper.Path(u,v);
 p.strokeColor = 'magenta';
 p.strokeWidth = 2;
 this.group.addChild(p);
};

linear_2d.draw_flow_lines = function(P) {
 this.flow_lines = P;
 for (i in P) {
  p = P[i];
  p.strokeColor = 'red';
  p.smooth();
 }
 this.group.addChildren(P);
};

linear_2d.fetch_flow_lines = function(url) {
 var x,L,LL,P,i,j;

 x = this.create_xhr();
 try {
  x.open('GET',url,false);
  x.send(null);
 } catch(e) {
  return (null);
 }

 if (x.status == 200) {
  LL = JSON.parse(x.responseText);
  for (i in LL) {
   L = LL[i];
   P = new paper.Path();
   for (j in L) {
    P.add(new paper.Point(L[j][0] * 1000, L[j][1] * 1000));
   }
   P.strokeColor = 'red';
   P.smooth();
   this.group.addChild(P);
  }
 }
};

linear_2d.fetch_explanation = function(url) {
 var x;

 x = this.create_xhr();
 try {
  x.open('GET',url,false);
  x.send(null);
 } catch(e) {
  return (null);
 }

 if (x.status == 200) {
  document.getElementById('explain').innerHTML = x.responseText;
 }
};

linear_2d.on_frame = function(event) {
 var i,a,live_walkers;

 live_walkers = [];
 for (i in this.walkers) {
  a = this.walkers[i];
  a.update(event.delta * 0.2);
  if (a.is_in_bounds()) {
   live_walkers.push(a);
  } else {
   a.marker.visible = false;
  }
 }

 this.walkers = live_walkers;
};

linear_2d.on_mouse_down = function(event) {
 var p = event.point;
 var q = this.group.localToGlobal(p);
 if (q.x * q.x + q.y * q.y < 1000000) {
  var a = this.walker.create(this.A);
  this.group.addChild(a.marker);
  a.place(q.x,q.y);
  this.walkers.push(a);
 }
}

linear_2d.walker = {
 x : 0,
 y : 0,
 axx : 0,
 axy : 0,
 ayx : 0,
 ayy : 0
};

linear_2d.walker.create = function(A) {
 var w = Object.create(this);
 w.set_matrix(A);
 w.create_marker();
 return w;
};

linear_2d.walker.set_matrix = function(A) {
 this.axx = A[0][0];
 this.axy = A[0][1];
 this.ayx = A[1][0];
 this.ayy = A[1][1];
};

linear_2d.walker.create_marker = function() {
 this.marker = new paper.Path.Circle(new paper.Point(this.x,this.y),10);
 this.marker.strokeColor = 'black';
 this.marker.fillColor = 'black';
};

linear_2d.walker.translate = function(dx,dy) {
 this.x += dx;
 this.y += dy;
 this.marker.translate(new paper.Point(dx,dy));
};

linear_2d.walker.place = function(x,y) {
 this.translate(x - this.x,y - this.y);
};

linear_2d.walker.update = function(dt) {
 var dx = (this.axx * this.x + this.axy * this.y) * dt;
 var dy = (this.ayx * this.x + this.ayy * this.y) * dt;
 this.translate(dx,dy);
};

linear_2d.walker.is_in_bounds = function() {
 return this.x * this.x + this.y * this.y < 1000000 ? true : false;
}

