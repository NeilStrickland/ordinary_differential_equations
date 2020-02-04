var ode = {};

ode.create = function() {
 var L = Object.create(this);

 L.group = null;
 L.running = true;
 L.view_type = 'rectangle';
 L.x_min = -1;
 L.x_max = +1;
 L.y_min = -1;
 L.y_max = +1;
 L.x_padding = 0;
 L.y_padding = 0;
 L.view_radius = 1;
 L.x_scale = 500;
 L.y_scale = 500;
 L.t_scale = 1;
 L.display_t_digits = 4;
 L.display_x_digits = 4;
 L.display_y_digits = 4;
 L.display_x_dot_digits = 4;
 L.display_y_dot_digits = 4;

 return L;
};

ode.create_xhr = function() {
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

ode.is_in_bounds = function(x,y) {
 if (this.view_type == 'rectangle') {
  return x >= this.x_min &&
         x <= this.x_max &&
         y >= this.y_min &&
         y <= this.y_max;
 } else if (this.view_type == 'disc') {
  return (x * x + y * y <= this.view_radius * this.view_radius);
 } else {
  return false;
 }
}

ode.create_group = function() {
 var X_min = this.x_min * this.x_scale;
 var X_max = this.x_max * this.x_scale;
 var X_size = X_max - X_min;
 var Y_min = this.y_min * this.y_scale;
 var Y_max = this.y_max * this.y_scale;
 var Y_size = Y_max - Y_min;

// paper.view.viewSize = new paper.Size(X_size,Y_size);

 this.outer_group = new paper.Group();

 this.group = new paper.Group();
 this.group.transformContent = false;
 this.group.translate(new paper.Point(-this.x_min+this.x_padding,
                                      -this.y_max-this.y_padding));
 this.group.scale(this.x_scale,- this.y_scale);

 this.outer_group.addChild(this.group);

 var M = this.group.matrix;
 var bl = M.transform(new paper.Point(this.x_min,this.y_min));
 var br = M.transform(new paper.Point(this.x_max,this.y_min));
 var tl = M.transform(new paper.Point(this.x_min,this.y_max));
 var tr = M.transform(new paper.Point(this.x_max,this.y_max));
 
 this.mask = new paper.Path(bl,br,tr,tl,bl);
 this.mask.closed = true;
 this.outer_group.insertChild(0,this.mask);
 this.outer_group.clipped = true;
};

ode.draw_outline = function() {
 if (! this.group) { this.create_group(); }

 if (this.view_type == 'rectangle') {
  this.outline = new paper.Path(
   [this.x_min,this.y_min],
   [this.x_max,this.y_min],
   [this.x_max,this.y_max],
   [this.x_min,this.y_max]
  );
  this.outline.closed = true;
  this.outline.strokeWidth = 4/this.x_scale;
  this.outline.strokeColor = 'grey';
  this.group.addChild(this.outline);
 } else if (this.view_type == 'disc') {
  this.outline = new paper.Path.Circle(new paper.Point(0,0),this.view_radius);
  this.outline.strokeWidth = 2/this.x_scale;
  this.outline.strokeColor = 'grey';
  this.group.addChild(this.outline);
 }
}

ode.set_display = function() {
 this.display_x     = document.getElementById('display_x');
 this.display_x_dot = document.getElementById('display_x_dot');
 this.display_y     = document.getElementById('display_y');
 this.display_y_dot = document.getElementById('display_y_dot');

 if (this.display_digits) {
  this.display_x_digits = this.display_digits;
  this.display_y_digits = this.display_digits;
  this.display_x_dot_digits = this.display_digits;
  this.display_y_dot_digits = this.display_digits;
 }
}

ode.set_lyapunov_display = function() {
 this.display_V     = document.getElementById('display_V');
 this.display_V_dot = document.getElementById('display_V_dot');

 if (this.display_digits) {
  this.display_V_digits = this.display_digits;
  this.display_V_dot_digits = this.display_digits;
 }
}

ode.create_walker = function() {
 var w = {  t : 0, x : 0,  y : 0 };

 if (this.view_type == 'rectangle') {
  w.x = 0.5 * (this.x_min + this.x_max);
  w.y = 0.5 * (this.y_min + this.y_max);
 }

 if (this.x_scale == this.y_scale) {
  var r = 3. / this.x_scale;
  w.marker = 
   new paper.Path.Circle(new paper.Point(w.x,w.y),r);
 } else {
  var rx = 3. / this.x_scale;
  var ry = 3. / this.y_scale;
  var corner = new paper.Point(w.x-rx,w.y-ry);
  var size = new paper.Size(2*rx,2*ry);
  var box = new paper.Rectangle(corner,size);
  w.marker = new paper.Path.Ellipse(box);
 }

 w.marker.fillColor = 'black';
 this.group.addChild(w.marker);

 this.walker = w;
};

ode.translate_walker = function(w,dx,dy,dt) {
 w.t += dt;
 w.x += dx;
 w.y += dy;
 w.marker.translate(new paper.Point(dx,dy));
 this.display_numbers(w.x,w.y,dx,dy,dt,w.t);

 if (w.hasOwnProperty('V')) {
  this.display_lyapunov_numbers(w.V,w.dV,dt);
 }

 if (this.trace_group && dt > 0) {
  var x0 = this.trace_x_scale * w.x;
  var y0 = this.trace_y_scale * w.y;

  if (this.log_count) {
   console.log('Adding x point at (' + w.t + ',' + x0 + ')');
   this.log_count--;
  }
  
  this.trace_x_path.add(new paper.Point(w.t,x0));
  this.trace_y_path.add(new paper.Point(w.t,y0));
 }
};

ode.display_numbers = function(x,y,dx,dy,dt,t) {
 var s;

 if (this.display_t) {
  var s = t.toFixed(this.display_t_digits);
  this.display_t.innerHTML = s;
 }

 if (this.display_x) {
  var s = x.toFixed(this.display_x_digits);
  this.display_x.innerHTML = s;
 }

 if (this.display_y) {
  var s = y.toFixed(this.display_y_digits);
  this.display_y.innerHTML = s;
 }

 if (this.display_x_dot) {
  if (dt) {
   var s = dx/dt;
   s = s.toFixed(this.display_x_dot_digits);
   this.display_x_dot.innerHTML = s;
  } else {
   this.display_x_dot.innerHTML = '';
  }
 }

 if (this.display_y_dot) {
  if (dt) {
   var s = dy/dt;
   s = s.toFixed(this.display_y_dot_digits);
   this.display_y_dot.innerHTML = s;
  } else {
   this.display_y_dot.innerHTML = '';
  }
 }
};

ode.display_lyapunov_numbers = function(V,dV,dt) {
 var s;

 if (this.display_V) {
  var s = V.toFixed(this.display_V_digits);
  this.display_V.innerHTML = s;
 }

 if (this.display_V_dot) {
  if (dt) {
   var s = dV/dt;
   s = s.toFixed(this.display_V_dot_digits);
   this.display_V_dot.innerHTML = s;
  } else {
   this.display_V_dot.innerHTML = '';
  }
 }
};

ode.place_walker = function(w,x,y) {
 w.t = 0;
 if (this.trace_group) {
  this.trace_x_path.removeSegments();
  this.trace_y_path.removeSegments();
 }
 
 this.translate_walker(w,x - w.x,y - w.y,0);
};

ode.draw_flow_lines = function(P) {
 this.flow_lines = P;
 for (i in P) {
  p = P[i];
  p.strokeColor = 'red';
  p.smooth();
 }
 this.group.addChildren(P);
};

ode.line_types = {
 'flow' : 'red',
 'x_nullcline' : 'cyan',
 'y_nullcline' : 'green',
 'contour' : 'blue',
 'first_eigenline' : 'magenta',
 'second_eigenline' : 'orange'
};

ode.fetch_lines = function(url) {
 var x,L,LL,P,i,j,p,q,M;

 x = this.create_xhr();
 try {
  x.open('GET',url,false);
  x.send(null);
 } catch(e) {
  return (null);
 }

 if (x.status == 200) {
  LL = JSON.parse(x.responseText);
  M = this.group.matrix;

  for (k in this.line_types) {
   var g = new paper.Group();
   this[k + '_group'] = g;
   this.outer_group.addChild(g);

   if (LL[k]) {
    for (i in LL[k]) {
     L = LL[k][i];
     P = new paper.Path();
     for (j in L) {
      p = new paper.Point(L[j][0], L[j][1]);
      q = M.transform(p);
      P.add(q);
     }
     P.strokeColor = this.line_types[k];
     P.smooth();
     this.outer_group.addChild(P);
     P.sendToBack();
    }
   }
  }
 }
};

ode.update_walker = function(w,dt) {
 var dx = 0;
 var dy = 0;

 this.translate_walker(w,dx,dy,dt);
};

ode.on_frame = function(event) {
 if (this.running) {
  var w = this.walker;
  if (this.is_in_bounds(w.x,w.y)) {
   this.update_walker(w,Math.min(event.delta,1000) * this.t_scale);
  }
 }
};

ode.on_mouse_down = function(event) {
 var p = event.point;
 var q = this.group.localToGlobal(p);
 if (this.is_in_bounds(q.x,q.y) && ! event.event.shiftKey) {
  this.place_walker(this.walker,q.x,q.y);
  this.running = true;
 } else {
  this.running = ! this.running;
 } 
}

ode.create_trace_group = function() {
 if (! this.trace_x_scale) { this.trace_x_scale = 1; }
 if (! this.trace_y_scale) { this.trace_y_scale = 1; }
 
 this.trace_outer_group = new paper.Group();
 this.trace_outer_group.translate(new paper.Point(this.trace_x_shift,
						  this.trace_y_shift));
 this.trace_group = new paper.Group();
 this.trace_group.transformContent = false;
 this.trace_group.translate(new paper.Point(this.trace_t_padding,
                                            -this.trace_v_max-this.trace_v_padding));
 this.trace_group.scale(this.trace_t_scale,-this.trace_v_scale);

 this.trace_outer_group.addChild(this.trace_group);

 var M = this.trace_group.matrix;
 var bl = M.transform(new paper.Point(               0,this.trace_v_min));
 var br = M.transform(new paper.Point(this.trace_t_max,this.trace_v_min));
 var tl = M.transform(new paper.Point(               0,this.trace_v_max));
 var tr = M.transform(new paper.Point(this.trace_t_max,this.trace_v_max));
 
 this.trace_mask = new paper.Path(bl,br,tr,tl,bl);
 this.trace_mask.closed = true;
 this.trace_outer_group.insertChild(0,this.trace_mask);
 this.trace_outer_group.clipped = true;

 var P;
 P = new paper.Path();
 P.add(new paper.Point(0,0));
 P.add(new paper.Point(this.trace_t_max,0));
 P.strokeColor = 'black';
 P.strokeWidth = 2/this.trace_v_scale;
 this.trace_group.addChild(P);

 P = new paper.Path();
 P.add(new paper.Point(0,this.trace_v_min));
 P.add(new paper.Point(0,this.trace_v_max));
 P.strokeColor = 'black';
 P.strokeWidth = 4/this.trace_t_scale;
 this.trace_group.addChild(P);

 this.trace_x_path = new paper.Path();
 this.trace_x_path.strokeColor = 'red';
 this.trace_x_path.strokeWidth = 2/this.trace_v_scale;
 this.trace_group.addChild(this.trace_x_path);

 this.trace_y_path = new paper.Path();
 this.trace_y_path.strokeColor = 'blue';
 this.trace_y_path.strokeWidth = 2/this.trace_v_scale;
 this.trace_group.addChild(this.trace_y_path);
};




