class Particle
{
  float x, y;
  float old_x, old_y;
  float vx, vy;
  float v_vx, v_vy;
  float u_vx, u_vy;
  float speed;
  float r_eff, R_eff, r_visual, r_view;
  float r_breathe = 0;
  float dt, age;
  float cR, cG, cB, cD;
  float p_alpha, m_alpha;
  int attractedCount = 0;

  float phase = random(PI * 2);
  float pace = random(0.01, 0.1);

  float repulsive_factor = 10;

  Particle()
  {
    dt = 0.05;
    cD = random(-64, 64);
    p_alpha = 0;
    m_alpha = 1;
  }

  void SetPosition(float x, float y)
  {
    this.x = x;
    this.y = y;
    old_x = x;
    old_y = y;
  }

  void Update()
  {
    if(!pause)
    {
      age += 0.1 + (max_speed / 100) * 0.1;
    }
    p_alpha += (m_alpha - p_alpha) * 0.1;
    r_breathe = (sin(frameCount * pace + phase) + 1) * r_eff * breathe_scale;
    R_eff = r_eff + r_breathe;
    r_view = R_eff * view_range;
    speed = sqrt(vx * vx + vy * vy);
    if(speed > 0)
    {
      u_vx = vx / speed;
      u_vy = vy / speed;
      if(speed > max_speed) speed = max_speed;
      vx = speed * u_vx;
      vy = speed * u_vy;
    }
    old_x = x;
    old_y = y;
    x += vx * dt;
    y += vy * dt;

    Interact();

    if(isBounded)
    {
      if(isPeriodicBound)
      {
        PeriodicBound();
      }
      else
      {
        Bound();
      }
    }
  }

  boolean PointInside(float px, float py)
  {
    float dx = px - x;
    float dy = py - y;
    float d2 = dx*dx + dy*dy;
    if(d2 < r_visual * r_visual)
    {
      return true;
    }
    return false;
  }

  void Interact()
  {
    attractedCount = 0;
    for(int i = 0; i < ps.size(); i++)
    {
      Particle other = (Particle)ps.get(i);
      if(this != other)
      {
        float dx = x - other.x;
        float dy = y - other.y;
        float d = sqrt(dx*dx + dy*dy);
        if(d > 0)
        {
          float u_fx = dx / d;
          float u_fy = dy / d;
          if(attractedCount < attractable_count)
          {
            Attract(other, d, u_fx, u_fy);
          }
          Repulse(other, d, u_fx, u_fy);
        }
      }
    }
  }



  void Repulse(Particle other, float d, float u_fx, float u_fy)
  {
    float R = R_eff + other.R_eff;
    if(d < R)
    {
      float power = (R - d) * 0.5;

      if(repulse_hard)
      {
        if(this != selectedPtcl)
        {
          x += u_fx * power;
          y += u_fy * power;
        }
        if(other != selectedPtcl)
        {
          other.x += -u_fx * power;
          other.y += -u_fy * power;
        }
      }
      if(repulse_bouncy)
      {
        vx += u_fx * power * repulsive_factor;
        vy += u_fy * power * repulsive_factor;
        other.vx += -u_fx * power * repulsive_factor;
        other.vy += -u_fy * power * repulsive_factor;
      }
    }  
  }

  void Attract(Particle other, float d, float u_fx, float u_fy)
  {
    if(d > R_eff && d < r_view)
    {
      float f = (d - R_eff) / (r_view - R_eff);
      float power = cos(f * PI * 0.5) * 2;
      vx += -u_fx * power;
      vy += -u_fy * power;
      if(show_network)
      {
        if(d < r_view)
        {
          int i0 = ps.indexOf(this);
          int i1 = ps.indexOf(other);
          if(i0 < i1)
          {
            Link li = new Link(this, other);
            if(!ls.contains(li)) ls.add(li);
          }
          else
          {
            Link li = new Link(other, this);
            if(!ls.contains(li)) ls.add(li);
          }
        }
      }
      attractedCount++;
    }   
  }

  void Bound()
  {
    m_alpha = 1;
    if(x < r_eff || x > pg.width-r_eff) vx += (pg.width * 0.5 - x) * dt;
    if(y < r_eff|| y > pg.height-r_eff) vy += (pg.height * 0.5 - y) * dt;
    x = constrain(x, r_eff, pg.width-r_eff);
    y = constrain(y, r_eff, pg.height-r_eff);
  }

  void PeriodicBound()
  {
    boolean inside = true;
    if(x < r_eff || x > pg.width-r_eff) inside = false;
    if(y < r_eff|| y > pg.height-r_eff) inside = false;
    if(inside) m_alpha = 1; else m_alpha = 0;
    
    float r_eff2 = r_eff * 2;
    if(x < -r_eff2) x = pg.width + r_eff;
    else if(x > pg.width + r_eff2) x = -r_eff;
    if(y < -r_eff2) y = pg.height + r_eff;
    else if(y > pg.height + r_eff2) y = -r_eff;
  }

  void Draw(PGraphics pg)
  {
    pg.fill(cR + cD, cG + cD, cB + cD, Alpha * p_alpha);
    r_visual = R_eff - 5;
    pg.ellipse(x, y, r_visual * 2, r_visual * 2);
  }

  void DrawV(PGraphics pg)
  {
    float r = r_visual - 2;
    pg.line(x, y, x + r* u_vx, y + r * u_vy);
  }

  void DrawTrail(PGraphics pg)
  {
    float dx = old_x - x;
    float dy = old_y - y;
    float d = sqrt(dx*dx+dy*dy);
    if(d < max_speed)
    {
      //float gr = (cR + cG + cB) / 3 + cD;
      pg.stroke(cR + cD, cG + cD, cB + cD, Alpha * p_alpha);
      pg.line(old_x, old_y, x, y);
    }
  }

  void DrawReff(PGraphics pg)
  {
    pg.stroke(0, 255, 0, 255);
    pg.ellipse(x, y, R_eff * 2, R_eff * 2); 
  }

  void DrawRview(PGraphics pg)
  {
    pg.stroke(0, 0, 255, 255);
    pg.ellipse(x, y, r_view * 2, r_view * 2); 
  }
}





